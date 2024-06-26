-- https://github.com/folke/lazy.nvim#-installation

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

vim.opt.termguicolors = true

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
		opts = {},
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"tpope/vim-commentary",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"MDeiml/tree-sitter-markdown",
		},
		build = ":TSUpdate",
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#00000000",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"benjaminbrassart/42header",
		opts = {
			user = "bbrassar",
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = {
			"MarkdownPreviewToggle",
			"MarkdownPreview",
			"MarkdownPreviewStop",
		},
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-d>"] = function(...)
							require("telescope.actions").delete_buffer(...)
						end,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"folke/which-key.nvim",
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		opts = {
			select = {
				backend = {
					"telescope",
					"fzf_lua",
					"fzf",
					"builtin",
				},
			},
		},
	},
})

vim.cmd.colorscheme "catppuccin"
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = "tab:→ ,trail:·,extends:»,precedes:«,space:·"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.relativenumber = false
vim.opt.wrap = false

vim.notify = require("notify")

local lsps = {
	clangd = {},
	gopls = {},
	rust_analyzer = {},
	taplo = {},
	dockerls = {},
	lua_ls = {
		on_init = function(client)
			local path = client.workspace_folders[1].name

			if not vim.loop.fs_stat(path .. "/.luarc.json") then
				client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				})

				client.notify("workspace/didChangeConfiguration", {
					settings = client.config.settings,
				})
			end

			return true
		end,
	},
}

require("mason").setup {}
require("mason-lspconfig").setup {
	ensure_installed = lsps,
	automatic_installation = true,
}

for lsp, config in pairs(lsps) do
	require("lspconfig")[lsp].setup(config)
end

vim.api.nvim_set_keymap("n", "<F2>", ":Stdheader<CR>", { noremap = true })

local augroup = vim.api.nvim_create_augroup("benjaminbrassart/dotfiles", {
	clear = true,
})

local function trim_whitespaces()
	vim.cmd("%s/\\s\\+$//e")
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup,
	callback = trim_whitespaces,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup,
	pattern = { "*/libft/*.c", "*/libft/*.h" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})
vim.keymap.set("n", "<leader>fe", telescope_builtin.diagnostics, {})
vim.keymap.set("n", "<leader>fm", telescope_builtin.marks, {})

-- local dapui = require("dapui")

-- dapui.setup({})

-- vim.keymap.set("n", "<leader>dt", dapui.toggle)
-- vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
-- vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
-- vim.keymap.set("n", "<leader>dr", ":DapUiToggle<CR>")

vim.keymap.set({ "n", "i" }, "<C-space>", vim.lsp.omnifunc)

-- https://github.com/neovim/nvim-lspconfig#suggested-configuration
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = {
			buffer = ev.buf,
		}

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, opts)
		vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, opts)
		vim.keymap.set("n", "gr", telescope_builtin.lsp_references, opts)

		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>F", function()
			vim.lsp.buf.format({
				async = true,
			})
		end, opts)
		vim.keymap.set({ "n", "i" }, "<C-space>", vim.lsp.omnifunc, opts)
	end,
})
