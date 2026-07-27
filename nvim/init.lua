vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true

-- Indentação
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Busca
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Comportamento
opt.clipboard = "unnamedplus"
opt.swapfile = false

-- Mapeamento de teclas
local keymap = vim.keymap.set

keymap("n", "<C-s>", ":w<CR>", { desc = "Salvar arquivo" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Sair" })

keymap("n", "<Esc>", ":nohlsearch<CR>")

keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Dividir verticalmente" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Dividir horizontalmente" })

keymap("n", "<leader>e", ":Ex<CR>", { desc = "Explorador de arquivos" })
