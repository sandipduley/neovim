-- ── UI / Display ──────────────────────────────────────────────────────────────
vim.opt.termguicolors = true -- true color
vim.opt.number = true -- absolute line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.numberwidth = 2
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- always show signcolumn
vim.opt.showmode = false -- hidden (lualine shows it)
vim.opt.showtabline = 1 -- only when >1 tab
vim.opt.cmdheight = 1
vim.opt.conceallevel = 0 -- show markdown backticks

-- ── Window / Scrolling ────────────────────────────────────────────────────────
vim.opt.wrap = false
vim.opt.linebreak = true -- don't break mid-word
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ── Mouse / Clipboard ─────────────────────────────────────────────────────────
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- ── Indentation ───────────────────────────────────────────────────────────────
vim.opt.expandtab = true -- tabs → spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true -- indent wrapped lines

-- ── Search ────────────────────────────────────────────────────────────────────
vim.opt.hlsearch = true
vim.opt.smartcase = true
-- vim.opt.ignorecase = true   -- uncomment to enable case-insensitive base

-- ── Undo / Backup / Swap ──────────────────────────────────────────────────────
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- ── Completion ────────────────────────────────────────────────────────────────
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 10
vim.opt.shortmess:append("c") -- suppress completion messages

-- ── Timing ────────────────────────────────────────────────────────────────────
vim.opt.updatetime = 250 -- faster CursorHold / gitsigns
vim.opt.timeoutlen = 300 -- which-key trigger delay

-- ── Movement ──────────────────────────────────────────────────────────────────
vim.opt.whichwrap = "bs<>[]hl"
vim.opt.backspace = "indent,eol,start"

-- ── Files ─────────────────────────────────────────────────────────────────────
vim.opt.fileencoding = "utf-8"
vim.opt.fixeol = true -- ensure single newline at end of file

-- ── Formatting / Keywords ─────────────────────────────────────────────────────
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- no auto comment continuation
vim.opt.iskeyword:append("-") -- hyphenated-words as one token

-- ── Runtime path ──────────────────────────────────────────────────────────────
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")
