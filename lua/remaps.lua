vim.g.mapleader = " "

vim.opt.wrap = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir";
vim.opt.undofile = true;

vim.opt.incsearch = true;

vim.opt.termguicolors = true;

vim.opt.scrolloff = 8;

vim.opt.updatetime = 50;

vim.opt.colorcolumn = "80";


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
