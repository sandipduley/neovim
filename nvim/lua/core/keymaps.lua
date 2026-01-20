-- leader keys (main prefix keys)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- common keymap options (no remap + silent)
local opts = { noremap = true, silent = true }

-- disable default space key behavior
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", opts)

-- move by visual lines when lines are wrapped
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- keep cursor vertically centered while scrolling/searching
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts) -- scroll down + center
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts) -- scroll up + center
vim.keymap.set("n", "n", "nzzzv", opts) -- next search result + center
vim.keymap.set("n", "N", "Nzzzv", opts) -- previous search result + center

-- clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", opts)

-- save and quit shortcuts
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", opts) -- save file
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts) -- quit window

-- editing helpers
vim.keymap.set("n", "x", '"_x', opts) -- delete without yanking
vim.keymap.set("n", "<leader>+", "<C-a>", opts) -- increment number
vim.keymap.set("n", "<leader>-", "<C-x>", opts) -- decrement number

-- window splits
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- vertical split
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- horizontal split
vim.keymap.set("n", "<leader>xs", "<cmd>close<CR>", opts) -- close split

-- window navigation
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) -- move to upper window
vim.keymap.set("n", "<C-j>", "<C-w>j", opts) -- move to lower window
vim.keymap.set("n", "<C-h>", "<C-w>h", opts) -- move to left window
vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- move to right window

-- window resizing
vim.keymap.set("n", "<Up>", "<cmd>resize -2<CR>", opts) -- shrink height
vim.keymap.set("n", "<Down>", "<cmd>resize +2<CR>", opts) -- increase height
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<CR>", opts) -- shrink width
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<CR>", opts) -- increase width

-- buffer management
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", opts) -- next buffer
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", opts) -- previous buffer
vim.keymap.set("n", "<leader>x", "<cmd>Bdelete!<CR>", opts) -- delete buffer
vim.keymap.set("n", "<leader>b", "<cmd>enew<CR>", opts) -- new empty buffer
vim.keymap.set("n", "<C-i>", "<C-i>", opts) -- preserve default <C-i>

-- tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts) -- close tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", opts) -- next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", opts) -- previous tab

-- quick escape from insert mode
vim.keymap.set("i", "jj", "<Esc>:w<CR>", opts)
vim.keymap.set("i", "kk", "<ESC><CR>", opts)
vim.keymap.set("i", "jk", "<ESC>:w<CR>", opts)

-- visual mode helpers
vim.keymap.set("v", "<", "<gv", opts) -- indent left and keep selection
vim.keymap.set("v", ">", ">gv", opts) -- indent right and keep selection
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts) -- move selection down
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts) -- move selection up
vim.keymap.set("v", "p", '"_dP', opts) -- paste without overwriting yank

-- system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- copy to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- copy line to clipboard

-- misc utilities
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts) -- toggle line wrap
vim.keymap.set("n", "<leader>j", "*``cgn", opts) -- search word & replace

-- diagnostics toggle
local diagnostics_enabled = true
vim.keymap.set("n", "<leader>do", function()
	diagnostics_enabled = not diagnostics_enabled
	vim.diagnostic.enable(diagnostics_enabled)
end)

-- diagnostics navigation
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end) -- previous diagnostic

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end) -- next diagnostic

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float) -- show diagnostic
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist) -- diagnostics list

-- session management
vim.keymap.set("n", "<leader>ss", "<cmd>mksession! .session.vim<CR>", { silent = true }) -- save session
vim.keymap.set("n", "<leader>sl", "<cmd>source .session.vim<CR>", { silent = true }) -- load session

-- tiny-inline-diagnostics controls
vim.keymap.set("n", "<leader>ed", "<cmd>TinyInlineDiag enable<CR>") -- enable inline diagnostics
vim.keymap.set("n", "<leader>dd", "<cmd>TinyInlineDiag disable<CR>") -- disable inline diagnostics
vim.keymap.set("n", "<leader>td", "<cmd>TinyInlineDiag toggle<CR>") -- toggle inline diagnostics
