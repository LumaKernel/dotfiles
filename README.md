# dotfiles

## Windows

まず WSL からやる

### WSL

WSLのインストールは頑張る．

```bash
# 気合で git を準備，バージョンアップは後でやる
# GitHub ssh セットアップ : https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
cd ~
git clone git@github.com:LumaKernel/dotfiles
cd dotfiles
sudo ./install-wsl.sh
```

### PowerShell

適当，スクリプトの破片にとどめて，いい感じにする

```powershell
iwr -useb https://get.scoop.sh | iex
scoop install git 7zip
# 気合
```

# License

[Unlicense](https://unlicense.org/)

ただし，`README.md` がおいてあるところ以下はそれに従う．  
ファイル内に注釈があるものもそれに従う．  
あまり信用してはいけない


# スクリーンショット

![image](https://user-images.githubusercontent.com/29811106/74127514-37f8bf00-4c1e-11ea-932c-2f6e15e44cd3.png)
![image](https://user-images.githubusercontent.com/29811106/73509583-f3517480-4422-11ea-979a-f62898945d96.png)
![image](https://user-images.githubusercontent.com/29811106/73509629-1c720500-4423-11ea-961b-47ff9c3391b4.png)

