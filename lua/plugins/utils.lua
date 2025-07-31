return {
	-- {
	-- 	"folke/which-key.nvim",
	-- 	keys = {
	-- 		{
	-- 			"<leader>?",
	-- 			function()
	-- 				require("which-key").show({ global = false })
	-- 			end,
	-- 			desc = "Buffer Local Keymaps (which-key)",
	-- 		},
	-- 	},
	-- },
	-- { "folke/neoconf.nvim", cmd = "Neoconf" },
	-- "folke/neodev.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"xiyaowong/telescope-emoji.nvim",
	"ghassan0/telescope-glyph.nvim",
	{ 'theprimeagen/harpoon' },
	{ 'mbbill/undotree' },
	{ 'tpope/vim-fugitive' },
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end,
		lazy = false
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
		},
	},
	{
		's1n7ax/nvim-window-picker',
		name = 'window-picker',
		event = 'VeryLazy',
		version = '2.*',
		config = function()
			require 'window-picker'.setup({
				hint = 'floating-big-letter'
			})
		end,
	},
	{
		'connordeckers/tmux-navigator.nvim',
		config = function()
			require('tmux-navigator').setup { enable = true, DisableMapping = true }
		end,
	},
	-- {
	--   'MagicDuck/grug-far.nvim',
	--   config = function()
	--     require('grug-far').setup({
	--       -- options, see Configuration section below
	--       -- there are no required options atm
	--       -- engine = 'ripgrep' is default, but 'astgrep' can be specified
	--     });
	--   end
	-- },
}
