# Pnpm Workspace Init
function pnpm_ws_init
  set -l path pnpm-workspace.yaml
  if test -f $path
    echo "ERROR: $path already exists.";
    return 1
  end

  echo "packages:
  # packages/ と components/ のすべてのサブディレクトリを含める
  - 'packages/**'
  - 'components/**'
  # test ディレクトリに含まれるすべてのパッケージを除外する
  - '!**/test/**'" > $path
end
