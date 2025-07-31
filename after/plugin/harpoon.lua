local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add to harpoon list" })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle harpoon list" })

vim.keymap.set("n", "<M-a>", function() ui.nav_file(1) end, { desc = "Harpoon #1 buffer" })
vim.keymap.set("n", "<M-s>", function() ui.nav_file(2) end, { desc = "Harpoon #2 bueffer" })
vim.keymap.set("n", "<M-d>", function() ui.nav_file(3) end, { desc = "Harpoon #3 bueffer" })
vim.keymap.set("n", "<M-f>", function() ui.nav_file(4) end, { desc = "Harpoon #4 bueffer" })
