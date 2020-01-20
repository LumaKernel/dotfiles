$env:RunFromPowershell = 1

try{ if ( gcm chcp -ea 0 ) { chcp 65001 | Out-Null } } catch { }

$env_to_del = @(
  "VIM"
  "VIMRUNTIME"
  "MYVIMRC"
  "MYGVIMRC"
)

foreach ($var in $env_to_del) {
  Remove-Item env:$var -ErrorAction SilentlyContinue
}


# Console の設定

try {
  [console]::BufferHeight = [math]::Max(3000, [console]::BufferHeight)
} catch { }


# GUI の設定

try {
  $Host.UI.RawUI.BackgroundColor = "Black"
  $Host.UI.RawUI.ForegroundColor = "White"
} catch { }



# -- エイリアス
# PowerShell のエイリアスは微妙ガチな気もする
# - 単なる置き換えではない
# - パラメータも置き換えではないのでめんどい
#   (関数定義すればパラメータを渡すことはできる)

Set-Alias checkvers ~/scoop/apps/scoop/current/bin/checkver.ps1

Set-Alias vim nvim -Force



# -- pshazz の設定
# エンコーディングを破壊されるので，pshazz 向けにわざとスタイルを壊す
# https://github.com/lukesampson/pshazz/blob/master/bin/install.ps1
# まあ， pshazz が悪いのではなく，乱立するエンコーディングが悪い
# や，Windows関連のファイルを UTF-16 で管理しないほうが悪いか…

if (gcm pshazz -ea 0) { 
  function Init-Pshazz {
    function global:pshazz_rightarrow {
        return (([char]0xe0b8) + " ")
    }
  }

  try {
    pshazz use lumc-shell
    pshazz init
    Init-Pshazz
  } catch { }


  function Start-Demo {
    try {
      echo "Use `".`$prfile`" to end.`n`n"
      pshazz use demo
      pshazz init
      Init-Pshazz
    } catch { }
  }

  Set-Alias demo Start-Demo
}

