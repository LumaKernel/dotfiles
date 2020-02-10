# dotfiles

Vim などの関連ファイル

## Windows

```powershell
iwr -useb https://git.io/JvLc6 | iex
```

### WSL

```bash
# Windows 側で dotfiles を導入してから，WSL 上で，
ln -sf /mnt/c/Users/`cmd.exe /c echo %UserName% | tr -d '\r'`/dotfils ~
sudo ~/install-wsl.sh
```

# License

[Unlicense](https://unlicense.org/)

ただし，`README.md` がおいてあるところ以下はそれに従う．


# スクリーンショット

![image](https://user-images.githubusercontent.com/29811106/74127514-37f8bf00-4c1e-11ea-932c-2f6e15e44cd3.png)
![image](https://user-images.githubusercontent.com/29811106/73509583-f3517480-4422-11ea-979a-f62898945d96.png)
![image](https://user-images.githubusercontent.com/29811106/73509629-1c720500-4423-11ea-961b-47ff9c3391b4.png)

