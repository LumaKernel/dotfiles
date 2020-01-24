# dotfiles

❤ vim などの関連ファイル

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

