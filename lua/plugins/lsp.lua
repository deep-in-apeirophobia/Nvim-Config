return {
	{
		'nvim-treesitter/nvim-treesitter',
		cmd = 'TSUpdate',
		config = function()
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require('nvim-treesitter.configs').setup {
				ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'javascript', 'typescript', 'python' },
				-- Autoinstall languages that are not installed
				auto_install = true,
				highlight = { enable = false },
				indent = { enable = true },
			}

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	{ 'nvim-treesitter/nvim-treesitter-context' },

	{
		'mason-org/mason.nvim',
		tag = 'v1.11.0',
		pin = true,
		lazy = false,
		opts = {},
	},
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		tag = 'v1.32.0',
		pin = true,
		lazy = true,
		config = false,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip' },
		},
		-- 	local cmp_mappings = lsp.defaults.cmp_mappings({
		-- 		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		-- 		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		-- 		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		-- 		["<C-Space>"] = cmp.mapping.complete(),
		-- 	})
		-- 	
		-- 	cmp_mappings['<Tab>'] = nil
		-- 	cmp_mappings['<S-Tab>'] = nil
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{ name = 'nvim_lsp' },
				},
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end,
	},

	-- Formatter
	{
		'mhartington/formatter.nvim',
		config = function()
			require("formatter").setup({

			})
		end,
	},

	-- Lint
	{
		'mfussenegger/nvim-lint',
		config = function()
		end,
	},

	-- LSP
	-- {
	-- 	'VonHeikemen/lsp-zero.nvim',
	-- 	branch = 'v4.x',
	-- 	lazy = true,
	-- 	config = function()
	-- 		-- local lsp = require("lsp-zero")
	--
	-- 		-- lsp.preset("recommended")
	-- 		-- lsp.setup()
	--
	-- 		-- lsp.ensure_installed({
	-- 		-- 	'tsserver',
	-- 		-- 	'eslint',
	-- 		-- 	'autopep8',
	-- 		-- 	'sumneko_lua',
	-- 		-- 	'rust_analyzer',
	-- 		-- 	"eslint-lsp",
	-- 		-- 	"autopep8",
	-- 		-- 	"docker-compose-lang",
	-- 		-- 	"dockerfile-language",
	-- 		-- 	"eslint_d",
	-- 		-- 	"prettier",
	-- 		-- 	"rustywind",
	-- 		-- 	"tailwindcss-languag",
	-- 		-- 	"vue-language-server",
	-- 		-- })
	--
	--
	-- 		-- Fix Undefined global 'vim'
	-- 		-- lsp.nvim_workspace()
	-- 	end
	-- },
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'mason-org/mason.nvim' },
			{ 'mason-org/mason-lspconfig.nvim' },
		},
		init = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = 'yes'
		end,
		config = function()
			local lsp_defaults = require('lspconfig').util.default_config

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lsp_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lsp_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)


			require('mason-lspconfig').setup({
				ensure_installed = {},
				automatic_enable = {
					'ts_ls',
				},
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,
				}
			})
		end
	},
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		opts = function()
			local conform = require("conform")
			---@type conform.setupOpts
			local opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false,      -- not recommended to change
					quiet = false,      -- not recommended to change
					lsp_format = "fallback", -- not recommended to change
				},
				formatters_by_ft = {
					lua = { "stylua" },
					fish = { "fish_indent" },
					sh = { "shfmt" },
					-- python = { "isort", "black", "autopep8", },
					python = { "ruff_format", "ruff_fix" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					vue = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
					scss = { "prettierd", "prettier", stop_after_first = true },
					less = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					jsonc = { "prettierd", "prettier", stop_after_first = true },
					yaml = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettierd", "prettier", stop_after_first = true },
					["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
					graphql = { "prettierd", "prettier", stop_after_first = true },
					handlebars = { "prettierd", "prettier", stop_after_first = true },
				},
				---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
				formatters = {
					injected = { options = { ignore_errors = true } },
					ruff_format = {
						args = { "format", "--config", "pyproject.toml", "--stdin-filename", "$FILENAME", "-" },
					},
					ruff_fix = {
						args = { "check", "--config", "pyproject.toml", "--fix", "--stdin-filename", "$FILENAME", "-" },
					},
					prettier = {
						condition = function(self, ctx)
							return vim.fs.find({
								".prettierrc",
								".prettierrc.json",
								".prettierrc.yml",
								".prettierrc.yaml",
								".prettierrc.json5",
								".prettierrc.js",
								".prettierrc.cjs",
								"prettier.config.js",
								"prettier.config.cjs",
							}, { path = ctx.filename, upward = true })[1]
						end,
					},
				},
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
			}
			return opts
		end,
		init = function()
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
			vim.keymap.set("", "<leader>f", function()
				require("conform").format({ async = true }, function(err)
					if not err then
						local mode = vim.api.nvim_get_mode().mode
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						end
					end
				end)
			end, { desc = "Format code" })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end
	},
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	}

}
