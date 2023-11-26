-- https://github.com/folke/lazy.nvim#-installation

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = true,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "catppuccin",
				section_separators = "",
				component_separators = "|",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
	{
		"rcarriga/nvim-notify",
	},
	{
		"benjaminbrassart/42header",
		opts = {
			user = "bbrassar",
		},
	},
})

vim.cmd.colorscheme "catppuccin"
vim.wo.number = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = "tab:→ ,trail:·,extends:>,precedes:<,space:·"

vim.notify = require("notify")
require("gitsigns").setup {}

vim.api.nvim_set_keymap("n", "<F2>", ":Stdheader<CR>", { noremap = true })

local augroup = vim.api.nvim_create_augroup("benjaminbrassart/dotfiles", {
	clear = true,
})

local function trim_whitespaces()
	vim.cmd("%s/\\s\\+$//e")
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = trim_whitespaces,
})
