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
	},
	{
		"nvim-lualine/lualine.nvim",
	},
	{
		"lewis6991/gitsigns.nvim",
	},
})

require("catppuccin").setup {
	flavour = "mocha",
	transparent_background = true,
}

require("lualine").setup {
	options = {
		theme = "catppuccin",
		icons_enabled = true,
		section_separators = "",
		component_separators = "|",
	},
}

vim.cmd.colorscheme "catppuccin"
vim.opt.nu = true
vim.opt.cc = "80"
vim.opt.cul = true
