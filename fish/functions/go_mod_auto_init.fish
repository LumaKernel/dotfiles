# Configure GO_MOD_AUTO_INIT_DOMAIN

function go_mod_auto_init
  if test -f go.mod
    echo "[error/go_mod_auto_init] go.mod found."
    return
  end

  if test -z "$GO_MOD_AUTO_INIT_DOMAIN"
    echo "[error/go_mod_auto_init] GO_MOD_AUTO_INIT_DOMAIN not configured."
    return
  end

  set -l GO_MODULE "$GO_MOD_AUTO_INIT_DOMAIN/"(basename (pwd))
  go mod init "$GO_MODULE"
end
