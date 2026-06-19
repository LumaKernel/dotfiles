---
name: install-copilot-kit
description: プロジェクトのHTMLダッシュボードやWebアプリに、AI Copilotチャットパネルを組み込む。Provider選択(Google AI / Vertex AI / Chrome Built-in AI)、ストリーミング応答、設定UI、コンテキスト自動収集、UI操作機能を含む。
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, AskUserQuestion
---

# AI Copilot Kit 組み込みスキル

HTMLベースのダッシュボードやWebアプリに、サイドパネル型のAI Copilotチャット機能を組み込む。

## 概要

以下をワンセットで埋め込む:

1. **FAB (Floating Action Button)** — 右下に常駐、クリックでパネル開閉
2. **チャットパネル** — サイドバー形式、ストリーミング応答、Markdown(GFM)レンダリング
3. **設定オーバーレイ** — Provider/認証/モデル選択UI
4. **コンテキスト自動収集** — ページ上のデータを自動的にLLMに送信
5. **UI操作 (Actions)** — LLMの応答に基づいてページのUI要素を操作(クリック、フィルタ切替、スクロール等)

## 手順

### Step 0: 対象の確認

`$ARGUMENTS` をパースする。以下の形式を受け付ける:

- ファイルパス: `/path/to/file.html`, `./dashboard.html`
- ディレクトリ: `/path/to/project/` → 内部のHTMLを探す

**対象が不明な場合は必ず AskUserQuestion で確認する。** 推測で進めない。

### Step 1: 設計提案の提示

対象ファイルを読み、以下を把握した上で**設計案をユーザーに提示し承認を得てから実装に進む**:

#### 1a. 既存構成の分析

- 既にCopilotが組み込まれているか（重複防止）
- 使用しているCSSフレームワーク / デザインシステム（色・フォント等を合わせる）
- `</body>` タグの位置（挿入ポイント）
- ページ内のデータ構造（JSグローバル変数、テーブル、JSON埋め込み等）
- 既存のフローティング要素（FAB位置の競合確認）

#### 1b. 設計案として提示する内容

以下をマークダウン表形式でまとめてユーザーに提示:

| 項目 | 設計 |
|------|------|
| 挿入位置 | `</body>` 直前、行番号 |
| デザイン統合 | 既存CSS変数を流用 or 独自定義 |
| コンテキスト収集 | 何のデータをどう取得するか |
| UI操作 | 登録するアクション一覧（後述） |
| FAB位置 | 既存UIとの競合有無、配置 |
| 依存追加 | marked.js 等 |

承認を得てから Step 2 へ。

### Step 2: UI操作(Actions)の設計

**LLMがユーザーの指示に応じてページのUIを操作できる仕組みを必ず提供する。**

#### アクションレジストリの設計

ページ上で操作可能なUI要素を分析し、アクションとして登録する。

```js
const ACTIONS = [
  { name: 'click_button', desc: 'ボタンをクリック', params: ['selector'] },
  { name: 'set_filter', desc: 'フィルタを切替', params: ['filterName', 'value'] },
  { name: 'switch_tab', desc: 'タブを切替', params: ['tabId'] },
  { name: 'scroll_to', desc: 'セクションにスクロール', params: ['selector'] },
  { name: 'toggle_section', desc: 'セクションの開閉', params: ['sectionId'] },
  // ... ページ固有のアクションを追加
];
```

#### 実装パターン

1. **アクション定義**: ページの操作可能要素を走査し、`ACTIONS` 配列を構築
2. **LLMへのアクション一覧提供**: system prompt 内にアクション一覧を含める
3. **LLMの応答パース**: 応答内に `:::action` ブロックがあれば実行

```
:::action
{"name":"scroll_to","params":{"selector":"#section05"}}
:::
```

4. **アクション実行エンジン**: パース結果に基づいてDOMを操作
5. **実行結果のフィードバック**: 成功/失敗をチャットに表示

#### アクション候補の自動検出

ページを分析して以下を自動検出:

- `<button>`, `<a>`, `[role="button"]` → クリックアクション
- `<select>`, `<input type="radio">`, `.filter-*`, `.tab-*` → 切替アクション
- `<section>`, `[id]` 付き要素 → スクロールアクション
- アコーディオン / コラプス要素 → トグルアクション
- `<input>`, `<textarea>` → 値設定アクション

#### system prompt への組み込み

```
あなたはページのUIを操作できます。ユーザーの指示に応じて以下のアクションを実行できます。
アクションを実行する場合は :::action ... ::: ブロックで記述してください。
複数のアクションを連続実行可能です。

利用可能なアクション:
- scroll_to(selector): 指定要素にスクロール
- click_button(selector): ボタンをクリック
  ...
```

### Step 3: コンテキスト収集関数の設計

ページ固有のデータをLLMに渡すための `buildCtx()` 関数を設計する。

- **フルコンテキスト版 (`buildCtx`)**: Google AI / Vertex AI 用。ページ上の主要データをJSON化
- **コンパクト版 (`buildCtxCompact`)**: Chrome Built-in AI (Gemini Nano) 用。コンテキストウィンドウが極小(~4K tokens)のため、要約・集計値のみに絞る

ポイント:
- ページ上のグローバル変数やDOM要素から動的にデータを取得
- 大きすぎるデータ（個別明細等）は除外し、集計値やTop N に絞る
- コンパクト版ではさらに数値を丸め、テキストを最小化
- **現在のUI状態**（選択中のフィルタ、表示中のタブ等）もコンテキストに含める

### Step 4: 埋め込みコードの生成と挿入

`</body>` の直前に以下を一括挿入する:

#### 依存ライブラリ

```html
<script src="https://cdn.jsdelivr.net/npm/marked@15/marked.min.js"></script>
```

※既に `marked` がロード済みなら不要。

#### UI構成要素

以下の3ブロックを挿入（`<style>`, HTML, `<script>`）:

1. **CSS**: FAB、パネル、メッセージ、設定オーバーレイ、アクション実行通知のスタイル
   - 既存のデザイン変数（CSS custom properties）があればそれに合わせる
   - なければ自前で `:root` にニュートラルな変数を定義
   - パネル幅はデフォルト440px、z-indexは9998/9999
   - アクション実行通知用のトースト/インラインメッセージのスタイル

2. **HTML**: FAB + パネル + 設定オーバーレイ
   - FABは `position:fixed; bottom:28px; right:28px`（競合時は調整）
   - パネルはページ右端からスライドイン
   - 設定には以下のProvider選択肢:
     - **Google AI (Gemini)** — API Key方式。モデル候補: gemini-2.5-flash, gemini-2.5-flash-lite, gemini-2.5-pro
     - **Vertex AI** — Service Account Key JSON方式（JSONテキスト貼付け）。GeminiとClaude両方のモデルを単一Providerで選択可能。モデル候補: gemini-2.5-flash, gemini-2.5-flash-lite, gemini-2.5-pro, claude-sonnet-4-6, claude-haiku-4-5, claude-opus-4-6。Region入力はオートコンプリート付き（主要リージョン候補を提示）
     - **Chrome Built-in AI (Gemini Nano)** — 認証不要。`self.ai.languageModel` の存在と `capabilities()` を検出し、利用可否を表示

3. **JavaScript** (即時実行関数で囲む):
   - localStorage でのconfig/history永続化
   - Provider別のAPI呼び出し:
     - Google AI: `generativelanguage.googleapis.com` REST + SSE
     - Vertex AI: SA Key JSON → JWTでアクセストークン自動取得。Geminiモデル選択時は `aiplatform.googleapis.com` REST + SSE、Claudeモデル選択時は `streamRawPredict` エンドポイント + Anthropic SSE形式。Claude非対応リージョンの場合は自動切替（`us-east5` へフォールバック）
     - Chrome Built-in AI: `self.ai.languageModel.create()` + `promptStreaming()`。コンパクト版コンテキストを使用
   - ストリーミング応答のインクリメンタル描画
   - `marked.parse()` によるGFM→HTMLレンダリング
   - **アクションパーサ + 実行エンジン**
   - **履歴クリア**: パネルヘッダ等に会話履歴を消去するボタンを配置（localStorage の履歴も削除）

### Step 5: 設定UIの工夫

- Provider切替でフィールドグループを表示/非表示（`.fg.active` パターン）
- Chrome AI 選択時に `self.ai.languageModel.capabilities()` を呼び、状態を自動表示:
  - `readily` → 利用可能
  - `after-download` → モデルダウンロード後に利用可能
  - API未検出 → フラグ有効化の案内（`chrome://flags/#prompt-api-for-gemini-nano`）
- Vertex AI でClaude モデル選択時、非対応リージョン（asia-*等）の場合は送信時に自動切替し、sysMsg で通知
- SA Key JSON の平文保存警告を表示

## 設計原則

- **自己完結**: 外部依存は `marked.js` のみ（フレームワーク不要）
- **非破壊**: 既存のページ機能に影響しない。即時実行関数でスコープ隔離
- **永続化**: config と会話履歴は localStorage に保存。キー名はページタイトルベースでユニーク化
- **セキュリティ警告**: SA Key JSON の平文保存について明示的に警告UI
- **レスポンシブ**: パネルは `position:fixed` で、ページレイアウトに依存しない
- **設計先行**: 実装前に必ず設計案を提示し承認を得る

## コンテキスト収集のパターン集

対象ページの種類に応じて `buildCtx` の実装を変える:

| ページ種別 | 収集対象 |
|-----------|---------|
| データダッシュボード | JSグローバル変数のJSON、KPI値、フィルタ状態、現在選択中のモード |
| テーブル中心のページ | テーブルヘッダ＋データ行をJSON化、ソート/フィルタ状態 |
| フォーム画面 | 入力フィールドの現在値、バリデーション状態 |
| 汎用ページ | `document.title` + 主要セクションの `textContent` |

## UI操作のパターン集

| ページ種別 | 登録すべきアクション |
|-----------|-------------------|
| データダッシュボード | モード切替、フィルタ切替、セクションスクロール、ドロワー開閉、期間切替 |
| テーブル中心 | ソート変更、ページネーション、行選択、フィルタ |
| フォーム | フィールド入力、バリデーション実行、送信 |
| タブUI | タブ切替、アコーディオン開閉 |

## 注意事項

- `marked.js` が既にロード済みか確認し、重複ロードしない
- CSS変数は既存のものがあればそれを使い、独自変数は最小限に
- 会話履歴の localStorage キーはページ固有にする（複数ページで共存可能に）
- Chrome Built-in AI は Prompt API の仕様変更に注意（`self.ai.languageModel` の存在チェックを必ず行う）
- アクション実行は応答のストリーミング完了後にまとめて行う（途中実行しない）
- アクションのセレクタが見つからない場合はエラーを握りつぶさず、チャットにフィードバックする
