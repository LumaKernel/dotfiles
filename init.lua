-- mode_preset: "huge" | "light" | "compe"
local mode_preset = os.getenv("VIM_MODE_PRESET") or "huge"
vim.g.mode_preset = mode_preset

vim.g.switch_color_scheme_save_file = vim.fn.expand('~/.config/nvim/vim-color-scheme--' .. mode_preset .. '.txt')
local default_configs = {
  huge = {
    huge_mode = "yes",
    complete_mode = "coc",
    lsp_mode = "coc",
    ts_lsp_mode = "none",
    hl_mode = "treesitter",
  },
  light = {
    huge_mode = "no",
    complete_mode = "none",
    lsp_mode = "none",
    ts_lsp_mode = "none",
    hl_mode = "none",
  },
  compe = {
    huge_mode = "yes",
    complete_mode = "ddc",
    lsp_mode = "nvim-lsp",
    ts_lsp_mode = "none",
    hl_mode = "none",
  },
}

-- huge_mode: "yes" | "no"
vim.g.huge_mode = os.getenv("VIM_HUGE_MODE") or default_configs[mode_preset].huge_mode
-- complete_mode: "none" | "ddc" | "coc"
vim.g.complete_mode = os.getenv("VIM_COMPLETE_MODE") or default_configs[mode_preset].complete_mode
-- lsp_mode: "none" | "nvim-lsp" | "coc"
vim.g.lsp_mode = os.getenv("VIM_LSP_MODE") or default_configs[mode_preset].lsp_mode
-- ts_lsp_mode: "none" | "lsp" | "tsu"
vim.g.ts_lsp_mode = os.getenv("VIM_TS_LSP_MODE") or "none"
-- hl_mode: "none" | "treesitter"
vim.g.hl_mode = os.getenv("VIM_HL_MODE") or default_configs[mode_preset].hl_mode

vim.g.is_wsl = vim.fn.has('unix') == 1 and vim.fn.system('uname -r'):match('microsoft') or false
vim.g.from_pwsh = os.getenv('RunFromPowershell') == '1' or false

if vim.g.hl_mode == "treesitter" then
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
end


vim.g.mapleader = " "

vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.virtualedit = "block"
vim.o.smartindent = true
vim.o.laststatus = 2
vim.o.title = false
vim.o.wrap = true
vim.o.completeopt = "menu"
vim.o.showmatch = false
vim.o.visualbell = false
vim.o.background = "dark"
vim.o.conceallevel = 0
vim.o.concealcursor = ""

;(function()
  local my_help_conceal_group = vim.api.nvim_create_augroup('my-help-conceal', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    pattern = '*',
    group = my_help_conceal_group,
    callback = function()
      if vim.bo.filetype == 'help' then
        vim.o.conceallevel = 0
        vim.o.concealcursor = ""
      end
    end
  })
end)()

vim.g.loaded_matchparen = 1

vim.cmd('set iskeyword+=-')
vim.cmd('set isfname+=@-@')

vim.o.swapfile = false
vim.o.autoread = false
vim.o.hidden = true
vim.o.showcmd = true

;(function()
  vim.o.backup = true
  local backupdir = vim.fn.expand('~/.tmp/nvim/backup')
  if vim.fn.isdirectory(backupdir) == 0 then
    vim.fn.mkdir(backupdir, 'p')
  end
  if vim.fn.isdirectory(backupdir) == 1 then
    vim.o.backupdir = backupdir
  end
end)()

;(function()
  vim.o.undofile = true
  local undodir = vim.fn.expand('~/.tmp/nvim/undofile')
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
  end
  if vim.fn.isdirectory(undodir) == 1 then
    vim.o.undodir = undodir
  end
end)()

vim.o.fileencodings = "utf-8,cp932,utf-16le,euc-jp,sjis"
vim.o.fileformats = "unix,dos"

vim.o.wildmode = "full"
vim.o.wildignorecase = true

vim.o.scrolloff = 7

-- vim.o.mouse = ""

vim.o.splitbelow = true
vim.o.splitright = true

vim.cmd('set matchpairs+=<:>')

vim.o.backspace = "indent,eol,start"
vim.o.belloff = "all"

vim.o.ttimeout = true
vim.o.timeout = false

vim.o.shortmess = "asToOFcI"

;(function()
  local my_ime_setting_group = vim.api.nvim_create_augroup('my-IME-setting', { clear = true })
  vim.o.iminsert = 0
  vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    pattern = '*',
    group = my_ime_setting_group,
    callback = function()
      vim.o.iminsert = 0
    end
  })
end)()

vim.o.ignorecase = true
vim.o.smartcase = false
vim.o.incsearch = true
vim.o.wrapscan = true
vim.o.hlsearch = true
vim.api.nvim_set_keymap('n', '<ESC><ESC>', ':<CMD>nohlsearch<CR><ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', ':<CMD>nohlsearch<CR><ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<SPACE>j', ':<CMD>ccl<CR>', { noremap = true, silent = true })

vim.cmd('set diffopt+=vertical')
vim.o.fixendofline = false

vim.o.list = true
vim.o.listchars = "tab:>-,eol:$,extends:≫,precedes:≪,nbsp:%"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2

-- set keywordprg=:help
vim.o.keywordprg = ":help"

if vim.fn.has('guirunning') == 0 and vim.fn.exists('&termguicolors') == 1 then
  vim.o.termguicolors = true
end

if vim.fn.has('guirunning') == 1 or vim.fn.exists('&termguicolors') == 1 then
  if vim.fn.exists('&pumblend') == 1 then
    vim.o.pumblend = 0
  end
  if vim.fn.exists('&winblend') == 1 then
    vim.o.winblend = 20
  end
end

vim.o.inccommand = "nosplit"


if vim.fn.has('win32') == 1 or vim.fn.has('win32unix') == 1 then
  vim.g.clipboard = {
    name = 'clip.exe + win32yank.exe for Windows',
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe"
    },
    paste = {
      ["+"] = "win32yank.exe -o",
      ["*"] = "win32yank.exe -o"
    },
    cache_enabled = 1,
  }
elseif is_wsl == 1 then
  vim.g.clipboard = {
    name = 'win32yank.exe from WSL',
    copy = {
      ["+"] = "win32yank.exe -i",
      ["*"] = "win32yank.exe -i"
    },
    paste = {
      ["+"] = "win32yank.exe -o",
      ["*"] = "win32yank.exe -o"
    },
    cache_enabled = 1,
  }
end

vim.g.python3_host_prog = vim.fn.systemlist('which python3')[1]

vim.api.nvim_create_user_command(
  'DiffOrig',
  function()
    vim.cmd([[
      vert new
      set bt=nofile
      r ++edit #
      0d_
      diffthis
      wincmd p
      diffthis
    ]])
  end,
  {}
)

-----------------------------------------------------------
---- Keymaps
-----------------------------------------------------------

vim.keymap.set('n', 'ZZ', '<NOP>', { noremap = true })
vim.keymap.set('n', 'ZQ', '<NOP>', { noremap = true })

vim.keymap.set('n', 'th', '<C-W>h', { noremap = true })
vim.keymap.set('n', 'tj', '<C-W>j', { noremap = true })
vim.keymap.set('n', 'tk', '<C-W>k', { noremap = true })
vim.keymap.set('n', 'tl', '<C-W>l', { noremap = true })
vim.keymap.set('n', 'tw', '<C-W>w', { noremap = true })

vim.keymap.set('n', 'tH', '<C-W>H', { noremap = true })
vim.keymap.set('n', 'tJ', '<C-W>J', { noremap = true })
vim.keymap.set('n', 'tK', '<C-W>K', { noremap = true })
vim.keymap.set('n', 'tL', '<C-W>L', { noremap = true })
vim.keymap.set('n', 'tr', '<C-W>r', { noremap = true })

vim.keymap.set('n', 't=', '<C-W>=', { noremap = true })
vim.keymap.set('n', 't>', '<C-W>>', { noremap = true })
vim.keymap.set('n', 't<', '<C-W><', { noremap = true })
vim.keymap.set('n', 't+', '<C-W>+', { noremap = true })
vim.keymap.set('n', 't-', '<C-W>-', { noremap = true })

vim.keymap.set('n', 'tt', '<Nop>', { noremap = true })

vim.keymap.set('n', 's', '<Nop>', { noremap = true })
vim.keymap.set('x', 's', '<Nop>', { noremap = true })

vim.keymap.set('i', '<C-L>', '<DEL>', { noremap = true })
vim.keymap.set('c', '<C-D>', '<DEL>', { noremap = true })

vim.keymap.set('n', '<F1>', '<Nop>', { noremap = true })
vim.keymap.set('x', '<F1>', '<Nop>', { noremap = true })

vim.keymap.set('n', '<A-:>', ':', { noremap = true })
vim.keymap.set('i', '<A-:>', '<C-o>:', { noremap = true })
vim.keymap.set('t', '<A-:>', '<C-\\><C-n>:', { noremap = true })

vim.keymap.set('n', '<A-/>', '/', { noremap = true })
vim.keymap.set('i', '<A-/>', '<C-o>/', { noremap = true })
vim.keymap.set('t', '<A-/>', '<C-\\><C-n>/', { noremap = true })

vim.keymap.set('n', '<A-ESC>', '<ESC>', { noremap = true })
vim.keymap.set('i', '<A-ESC>', '<ESC>', { noremap = true })
vim.keymap.set('t', '<A-ESC>', '<C-\\><C-n>', { noremap = true })

vim.keymap.set('n', '<A-]>', '<ESC>', { noremap = true })
vim.keymap.set('i', '<A-]>', '<ESC>', { noremap = true })
vim.keymap.set('t', '<A-]>', '<C-\\><C-n>', { noremap = true })

for _, wincmd in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('n', '<A-' .. wincmd .. '>', '<CMD>silent! call VimAndTmuxMove("' .. wincmd .. '", 0)<CR>', { noremap = true, silent = true })
  vim.keymap.set('x', '<A-' .. wincmd .. '>', '<CMD>silent! call VimAndTmuxMove("' .. wincmd .. '", 0)<CR>gv', { noremap = true, silent = true })
  vim.keymap.set('i', '<A-' .. wincmd .. '>', '<C-o><CMD>call VimAndTmuxMove("' .. wincmd .. '", 0)<CR>', { noremap = true, silent = true })
  vim.keymap.set('c', '<A-' .. wincmd .. '>', '<C-r>=<C-u>VimAndTmuxMove("' .. wincmd .. '", 1)<CR>', { noremap = true, silent = true })
  vim.keymap.set('t', '<A-' .. wincmd .. '>', '<C-\\><C-n>:<C-u>silent! call VimAndTmuxMove("' .. wincmd .. '", 0)<CR>', { noremap = true, silent = true })
end

vim.keymap.set('n', '<Leader>y', '<CMD>%y+<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>v', 'ggVGs<ESC>"+P', { noremap = true, silent = true })

vim.keymap.set({'n', 'v', 'o', 'x'}, '*', '<Plug>(asterisk-z*)')
vim.keymap.set({'n', 'v', 'o', 'x'}, '#', '<Plug>(asterisk-z*)N')
vim.keymap.set({'n', 'v', 'o', 'x'}, 'g*', '<Plug>(asterisk-gz*)')
vim.keymap.set({'n', 'v', 'o', 'x'}, 'g#', '<Plug>(asterisk-gz*)N')

if vim.g.lsp_mode == 'nvim-lsp' then
  vim.keymap.set('n', '[g', function()
    -- TODO: 0.11
    -- vim.diagnostic.jump({count= -1,float = true})
    vim.diagnostic.goto_prev()
  end)
  vim.keymap.set('n', ']g', function()
    -- TODO: 0.11
    -- vim.diagnostic.jump({count= 1,float = true})
    vim.diagnostic.goto_next()
  end)

  vim.keymap.set("n", "gr", function()
    local cmdId
    cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
      once = true,
      callback = function()
        local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
        vim.api.nvim_feedkeys(key, "c", false)
        vim.api.nvim_feedkeys("0", "n", false)
        cmdId = nil
        return true
      end,
    })
    vim.lsp.buf.rename()
    vim.defer_fn(function()
      if cmdId then
        vim.api.nvim_del_autocmd(cmdId)
      end
    end, 500)
  end, {})
  vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = false,
    update_in_insert = false,
  })

  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, { noremap = true, silent = true })

  local my_lsp_config_group = vim.api.nvim_create_augroup('my-lsp-config', { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*.rs",
    group = my_lsp_config_group,
    callback = function()
      vim.lsp.buf.format()
    end
  })

  vim.keymap.set("n", "Q", function()
    vim.lsp.buf.code_action()
  end)
end

_G.n_GTGT = function()
  local smartindent_save = vim.o.smartindent
  vim.o.smartindent = false
  vim.cmd('normal! >>')
  vim.o.smartindent = smartindent_save
end
vim.api.nvim_set_keymap('n', '>>', '<CMD>lua n_GTGT()<CR>', { noremap = true, silent = true })
_G.x_GT = function()
  local smartindent_save = vim.o.smartindent
  vim.o.smartindent = false
  vim.cmd('normal! >gv')
  vim.o.smartindent = smartindent_save
end
vim.api.nvim_set_keymap('x', '>', '<CMD>lua x_GT()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('x', '<LT>', '<LT>gv', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '0', [[getline('.')[: col('.') - 2] =~# '^\s\+$' ? '0' : '^']], { noremap = true, expr = true })

-- simeji/winresizer
-- <SPACE>w

vim.cmd('imap <C-t>, <Plug>(emmet-expand-abbr)')

-----------------------------------------------------------
---- Keymaps End
-----------------------------------------------------------


if vim.fn.has('gui_running') == 1 then
  vim.cmd('set guioptions+=e')
  -- メニューバーを消す
  vim.cmd('set guioptions-=m')
  -- ツールバーを消す
  vim.cmd('set guioptions-=T')
  -- スクロールバーを消す
  vim.cmd('set guioptions-=r')
  vim.cmd('set guioptions-=R')
  vim.cmd('set guioptions-=l')
  vim.cmd('set guioptions-=L')

  vim.o.guifont = 'RictyDiminished NF:h11'
end

if vim.g.from_pwsh then
  vim.cmd('colorscheme darkblue')
  vim.o.cursorline = false
  vim.o.cursorcolumn = false
end

;(function()
  local opamshare = vim.fn.substitute(vim.fn.system('opam var share'), '\n$', '', '\'')
  if vim.fn.isdirectory(opamshare) == 1 then
    vim.cmd('set rtp+=' .. opamshare .. '/merlin/vim')
  end
end)()

;(function()
  local my_colo_group = vim.api.nvim_create_augroup('my-color', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    pattern = '*',
    group = my_colo_group,
    callback = function()
      if vim.g.colors_name == 'darkblue' then
        vim.api.nvim_command('highlight Special ctermfg=DarkRed guifg=Orange')
        vim.api.nvim_command('highlight SpecialChar ctermfg=DarkRed guifg=Orange')
        vim.api.nvim_command('highlight SpecialComment ctermfg=DarkRed guifg=Orange')
        vim.api.nvim_command('highlight Tag ctermfg=DarkRed guifg=Orange')
        vim.api.nvim_command('highlight Delimiter ctermfg=DarkRed guifg=Orange')
        vim.api.nvim_command('highlight Debug ctermfg=DarkRed guifg=Orange')
      end
    end
  })
end)()


if vim.fn.filereadable(vim.fn.expand('~/local_profile.vim')) == 1 then
  vim.cmd('source ~/local_profile.vim')
end

vim.cmd('source ~/dotfiles/vim/dein-setting.vim')
