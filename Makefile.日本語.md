
# Windows

- 初期 で入ってるアプリを消す
- 壁紙は "minimalist wallpaper" などで検索
- 連絡用/娯楽アプリなどは都度入れる
- 設定系
  - 'windows の機能の有効化または無効化' > 必要なものを
    - VM
    - WSL
    - telnet client
  - 'sign in options' > アプリの再起動
  - 電源オプション
  - shift 5 回のアレ無効化
  - init.reg を入れる
  - 開発者向けみたいなやつ (拡張子表示など)
  - エクスプローラーのオプション > プライバシー，非表示設定に
  - CTRL + SHIFT での IME 切り替え無効化
    - https://superuser.com/a/1488169
    - キーボードの詳細設定 > 入力言語のホットキー > シーケンスの変更
- 絶対入れる
  - [PowerToys](https://github.com/microsoft/PowerToys)
    - 自動起動
  -  AutoHotKeys
    - init.ahk を設定する ( お試し中 )
- 入れる
  - WSL2
  - dotfiles 内のセットアップスクリプト
  - WireShark
  - Windows Terminal
  - ScreenToGif
  - Nmap
  - Gimp
  - Screen Ruler
  - Color Picker
  - Dokcer Desktop
    - 自動起動
  - https://github.com/QL-Win/QuickLook
  - Oracle VM VirtualBox + Vagrant
  - OBS
  - Voicemeeter
  - audacity
- [CorvusSKK](https://nathancorvussolis.github.io/)
  - 試運転中...
- 同一 LAN から WSL2 にアクセスできるようにする
  - https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723
  - [scripts/WSL2-bridge.ps1](scripts/WSL2-bridge.ps1)
  - これは一般的なフォワーディングの設定ができれば問題ないはずなんだよな...
    (とはいえ WSL2 に関して言えば事情が若干特殊っぽい, hostのwinからはループバックでアクセスできる，謎の技術)




# Mac

1. OSのバージョンを上げる
2. フォント入れる
  tty 全部選択して 開けばいい
  - https://github.com/macchaberrycream/RictyDiminished-Nerd-Fonts
3. git と GitHub への ssh接続 のセットアップ

xcodeも必要であれば

[SSHクライアントセットアップ](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)

```bash
ssh-keygen -t rsa -b 4096 -C "tomorinao.info@gmail.com"
eval "$(ssh-agent -s)"

echo <<EOF >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
EOF

ssh-add -K ~/.ssh/id_rsa

# GitHub に 公開鍵を登録
pbcopy ~/.ssh/id_rsa.pub
# GitHub 側に貼り付け

# git config
git config --global user.name Luma
git config --global user.email tomorinao.info@gmai.com

```

4. dotfiles でインストール

```
cd ~
git clone git@github.com:LumaKernel/dotfiles
cd dotfiles
sudo bash mac/install.sh
```

4. アプリ設定する (インストールは brew cask)
  - chrome
    * ログインなど
    * 拡張の設定
  - iterm2
    * フォントを設定
    * テーマを設定，などなど
  - Google IME
    *https://ke-complex-modifications.pqrs.org/ https://ke-complex-modifications.pqrs.org/日本語と英字のみ残す．切り替えは CTRL + SPACE
    * 設定をする
    * 後はユーザー辞書など
  - HyperSwitch
    * Command Space をのっとって便利に
  - Karabiner-Elements
    * https://ke-complex-modifications.pqrs.org/
    * Command + H や + Q などを消す
