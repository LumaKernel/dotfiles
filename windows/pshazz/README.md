# Luma's pshazz themes

pshazz/ 配下を Public Domain とします．

別のリポジトリにしたほうがいいかもしれない，需要があればそうする．

concfg で [lumc-vs-code-dark-plus.json](https://github.com/LumaKernel/dotfiles/master/windows/concfg/lumc-vs-code-dark-plus.json) を使うことを想定．

あまり色々なスタイルに対応するのもなあ，という感じ．one-dark とかかっこいいけど．


# 使い方

dotfiles とは別に，独立で使う方法．


### 前提

- `scoop`
- `scoop` で入れた `pshazz`


### 入れ方


```powershell
pshazz get https://rawgithubusercontent.com/LumaKernel/dotifles/master/windows/pshazz/themes/lumc-shell.json
pshazz get https://rawgithubusercontent.com/LumaKernel/dotifles/master/windows/pshazz/themes/demo.json
```

`demo` のほうは大したこと無いけど


### 設定

以下のようなものを， `$profile` の， `pshazz init` より後に書けば rightarrow を変更できる．

もちろん，上記の `json` ファイルを直接編集して書き換えるのもいいと思う．

```powershell
function global:pshazz_rightarrow {
  return (([char]0xe0b8) + " ")
}
```

