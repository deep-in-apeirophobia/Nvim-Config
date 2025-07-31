local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conform = require('conform')
local linter = require('lint')

vim.keymap.set('n', '<leader>wl', function()
	print(conform.list_formatters(vim.api.nvim_get_current_buf()))
	local picker = pickers.new({
		result_title = "Linters",
		finder = finders.new_table(conform.list_formatters(vim.api.nvim_get_current_buf())),


	})
	picker:find()
end, { desc = "Lint file" })
