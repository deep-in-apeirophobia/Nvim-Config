-- local cmp = require('cmp')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--   ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--   ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--   ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--   ["<C-Space>"] = cmp.mapping.complete(),
-- })
--
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil
--
-- lsp.setup_nvim_cmp({
--   mapping = cmp_mappings
-- })
--
-- lsp.set_preferences({
--     suggest_lsp_servers = false,
--     sign_icons = {
--         error = 'E',
--         warn = 'W',
--         hint = 'H',
--         info = 'I'
--     }
-- })
--
-- lsp.on_attach(function(client, bufnr)
--   local opts = {buffer = bufnr, remap = false}
--
--   vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--   vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--   vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--   vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--   vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--   vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--   vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--   vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
--   vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--   vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- end)
--
-- lsp.setup()
--
-- vim.diagnostic.config({
--     virtual_text = true
-- })
--
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'rounded' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'rounded' }
)

-- LspAttach is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }

		-- if not event.bufnr or type(event.buf) ~= "number" then
		-- 	return
		-- end

		local function nkeymapset(keymap, runner, description)
			vim.keymap.set("n", keymap, runner, { buffer = event.bufnr, remap = false, desc = description })
		end

		nkeymapset("gd", function() vim.lsp.buf.definition() end, "Goto definition")
		nkeymapset("gD", function() vim.lsp.buf.declaration() end, "Goto declaration")
		nkeymapset("K", function() vim.lsp.buf.hover() end, "Hover - View signature help")
		nkeymapset("<Leader>vws", function() vim.lsp.buf.workspace_symbol() end, "Workspace symbol")
		nkeymapset("<Leader>vd", function() vim.diagnostic.open_float() end, "Open diagnostic")
		nkeymapset("[d", function() vim.diagnostic.goto_next() end, "Goto next diagnostic")
		nkeymapset("]d", function() vim.diagnostic.goto_prev() end, "Goto previous diagnostic")
		nkeymapset("<Leader>vca", function() vim.lsp.buf.code_action() end, "Code action")
		nkeymapset("<Leader>vrr", function() vim.lsp.buf.references() end, "View references")
		nkeymapset("<Leader>vrn", function() vim.lsp.buf.rename() end, "Rename symbol")
		nkeymapset('<leader>q', vim.diagnostic.setloclist, "LSP: Show Diagnostics in Quickfix")
		nkeymapset('<leader>D', vim.diagnostic.open_float, "LSP: Show Line Diagnostics (Float)")
		vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
			{ buffer = event.bufnr, desc = "format" })
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
			{ buffer = event.bufnr, remap = false, desc = "View help" })
	end,
})

local lspconfig = vim.lsp.config
local util = require("lspconfig.util")

-- lspconfig.eslint.setup({
-- 	root_dir = function(fname)
-- 		local eslint_configs = {
-- 			".eslintrc.js",
-- 			".eslintrc.cjs",
-- 			".eslintrc.yaml",
-- 			".eslintrc.yml",
-- 			".eslintrc.json",
-- 			"eslint.config.js",
-- 			"eslint.config.cjs",
-- 			"eslint.config.ts",
-- 			"eslint.config.cts",
-- 			"package.json",
-- 		}
--
-- 		return util.root_pattern(unpack(eslint_configs))(fname)
-- 	end,
--
-- 	on_attach = function(client, bufnr)
-- 		-- vim.notify("ESLint LSP attached.", vim.log.levels.INFO)
-- 	end,
--
-- 	settings = {
-- 		validate = {
-- 			"javascript",
-- 			"javascriptreact",
-- 			"typescript",
-- 			"typescriptreact",
-- 		},
-- 	},
-- })

vim.lsp.enable('ts_ls', { 
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				-- location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
				location = "/home/atrin/.nvm/versions/node/v20.19.4/lib/node_modules/@vue/typescript-plugin",
				languages = { "javascript", "typescript", "vue" },
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
})
local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    if not base_on_attach then return end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.enable('clangd')
vim.lsp.enable('tailwindcss-intellisense')
vim.lsp.enable('css-languageserver')
vim.lsp.enable('css-languageserver')
vim.lsp.enable('dockerfile-language-server-nodejs')
vim.lsp.enable('gopls')
vim.lsp.enable('golangci-lint-langserver')
vim.lsp.enable('helm-ls')
vim.lsp.enable('html-languageserver')
vim.lsp.enable('biom')
vim.lsp.enable('json-languageserver')
vim.lsp.enable('ruff')
vim.lsp.enable('pyls-all')
vim.lsp.enable('pylsp')
vim.lsp.enable('ruff-lsp')

vim.lsp.enable('lua-ls')

-- lspconfig.volar.setup({})
