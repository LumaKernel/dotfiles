local M = {}

local function check(name, cmds, verpat, should_do)
  if should_do ~= nil and not should_do then
    return
  end
  verpat = '\\v' .. verpat

  if type(cmds[1]) == 'string' then
    return check(name, {cmds}, verpat)
  end

  local ok, ver
  for _, cmd in ipairs(cmds) do
    ok = vim.fn.executable(cmd[1]) == 1
    if ok then
      ver = vim.fn.trim(vim.fn.system(cmd))
      local p0, p1 = vim.regex(verpat):match_str(ver)
      if p0 ~= nil then
        ver = ver:sub(p0, p1)
      else
        ok = false
      end
    end
    if ok then break end
  end

  if ok then
    vim.health.ok(string.format('%s: Version %s found.', name, ver))
  else
    vim.health.error(string.format('%s: Not found.', name))
  end
end

local function checkfile(fname)
  if vim.fn.filereadable(vim.fn.expand(fname)) == 1 then
    vim.health.ok(string.format('%s: Found.', fname))
  else
    vim.health.error(string.format('%s: Not found.', fname))
  end
end

M.check = function()
  local is_mac = vim.fn.has('mac') == 1
  vim.health.start('my: Info')

  vim.health.info(string.format('uname -a : %s', vim.fn.system({'uname', '-a'})))
  if vim.fn.executable('dpkg') == 1 then
    vim.health.info(string.format('dpkg --print-architecture : %s', vim.fn.system({'dpkg', '--print-architecture'})))
  end

  vim.health.start('my: Basic Commands')
  local general_ver =  '\\d+\\.\\d+(\\.\\d+)?'

  check('fish', {'fish', '--version'}, general_ver)
  check('zsh', {'zsh', '--version'}, general_ver)
  check('make', {'make', '--version'}, general_ver)
  check('cmake', {'cmake', '--version'}, general_ver)
  check('find', {'find', '--version'}, general_ver, not is_mac)
  check('zip', {'zip', '--version'}, general_ver)
  check('vim', {'vim', '--version'}, general_ver)
  check('nvim', {'nvim', '--version'}, general_ver)
  check('git', {'git', '--version'}, general_ver)
  check('gh', {'gh', '--version'}, '(gh version )@<=[^\n\r]*')
  check('fzf', {'fzf', '--version'}, general_ver)
  check('npm', {'npm', '--version'}, general_ver)
  check('yarn', {'yarn', '--version'}, general_ver)
  check('pnpm', {'pnpm', '--version'}, general_ver)
  check('node', {'node', '--version'}, general_ver)
  check('dvm', {'dvm', '--version'}, general_ver)
  check('deno', {'deno', '--version'}, general_ver)
  check('pyenv', {'pyenv', '--version'}, general_ver)
  check('pip', {'pip', '--version'}, general_ver)
  check('pip3', {'pip3', '--version'}, general_ver)
  check('brew', {'brew', '--version'}, general_ver)
  check('rustup', {'rustup', '--version'}, '(rustup )@<=[^\n\r]*')
  check('cargo', {'cargo', '--version'}, general_ver)
  check('sccache', {'sccache', '--version'}, general_ver)
  check('go', {'go', 'version'}, general_ver)
  check('wasm-pack', {'wasm-pack', '--version'}, general_ver)
  check('fish-history-ui', {'fish-history-ui', '--version'}, general_ver)
  check('ghq', {'ghq', '--version'}, general_ver)
  check('tokei', {'tokei', '--version'}, general_ver)
  check('nmap', {'nmap', '--version'}, general_ver)
  check('lynx', {'lynx', '--version'}, general_ver)
  check('curl', {'curl', '--version'}, general_ver)
  check('wget', {'wget', '--version'}, general_ver)
  check('trash', {'trash', '--version'}, general_ver)
  check('lcov', {'lcov', '--version'}, general_ver)
  check('ruby', {'ruby', '--version'}, general_ver)
  check('perl', {'perl', '--version'}, general_ver)
  check('speedtest', {'speedtest', '--version'}, general_ver)

  vim.health.start('Rust tools')
  check('rustc', {'rustc', '--version'}, '\\d+\\.\\d+\\.\\d+')
  check('cargo-watch', {'cargo-watch', '--version'}, '\\d+\\.\\d+\\.\\d+')
  check('cargo-expand', {'cargo-expand', '--version'}, '\\d+\\.\\d+\\.\\d+')
  check('cargo-generate', {'cargo-generate', '--version'}, '\\d+\\.\\d+\\.\\d+')

  vim.health.start('my: OCaml Environment')
  check('opam', {'opam', '--version'}, '\\d+\\.\\d+\\.\\d+')
  check('ocaml', {'ocaml', '--version'}, 'The OCaml toplevel, version \\d+\\.\\d+\\.\\d+')
  check('merlin', {'opam', 'show', '--field', 'version', 'merlin'}, '^(\\d.*)')
  check('ocp-indent', {'opam', 'show', '--field', 'version', 'ocp-indent'}, '^(\\d.*)')

  vim.health.start('my: Additional Commands')
  check('bat', {'bat', '--version'}, general_ver)
  check('eza', {'eza', '--version'}, general_ver)
  check('procs', {'procs', '--version'}, general_ver)
  check('fd', {{'fd', '--version'}, {'fdfind', '--version'}}, general_ver)
  check('tidy', {'tidy', '--version'}, general_ver)
  check('nextword', {'nextword', '-v'}, general_ver)

  vim.health.start('my: Python Modules')
  check('flake8', {'python3', '-m', 'flake8', '--version'}, '\\d+\\.\\d+\\.\\d+')
  check('mypy', {'python3', '-m', 'mypy', '--version'}, 'mypy \\d+\\.\\d+')
  check('autopep8', {'python3', '-m', 'autopep8', '--version'}, 'autopep8 \\d+\\.\\d+\\.\\d+')
  check('isort', {'python3', '-m', 'isort', '--version'}, 'VERSION \\d+\\.\\d+\\.\\d+')

  vim.health.start('my: SKK-JISHO')
  local base_path
  if is_mac then
    base_path = '~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/'
  else
    base_path = '/usr/share/skk/'
  end
  local jisyo_path = base_path .. 'SKK-JISYO.L'
  checkfile(jisyo_path)
end

return M
