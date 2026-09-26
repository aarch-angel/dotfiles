-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Remove LazyVim default window resizing
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

-- map("n", "gk", function()
--   print("AAAAAA")
-- end, { desc = "HELP" })

-- hover.nvim
-- map("n", "K", require("hover").hover, { desc = "hover.nvim" })
-- map("n", "gk", require("hover").hover_select, { desc = "hover.nvim (select)" })
-- map("n", "<C-p>", function()
--   require("hover").hover_switch("previous")
-- end, { desc = "hover.nvim (previous source)" })
-- map("n", "<C-n>", function()
--   require("hover").hover_switch("next")
-- end, { desc = "hover.nvim (next source)" })
-- Mouse support
-- map("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
-- vim.o.mousemoveevent = true

-- Telescope file browser
map(
  "n",
  "<leader>.",
  "<CMD>Telescope file_browser path=%:p:h hidden=true no_ignore=true select_buffer=true<CR>",
  { desc = "Browse Files" }
)

-- require("telescope.builtin").find_files({
--   attach_mappings = function(_, map)
--     map("i", "asdf", function(_prompt_bufnr)
--       print("You typed asdf")
--     end)
--
--     map({ "i", "n" }, "<C-r>", function(_prompt_bufnr)
--       print("You typed <C-r>")
--     end, { desc = "desc for which key" })
--
--     -- needs to return true if you want to map default_mappings and
--     -- false if not
--     return true
--   end,
-- })

-- map("n", "<leader>.", function()
--   require("telescope").extensions.file_browser.file_browser()
-- end, { desc = "Browse Files" })

-- map("n", "<leader>.", "<CMD>FzfLua files cwd=%:p:h select_buffer=true<CR>", { desc = "Browse Current Directory" })

-- Add window resizing
map({ "n", "x", "i" }, "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map({ "n", "x", "i" }, "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map({ "n", "x", "i" }, "<C-S-Left>", "<cmd>vertical resize +2<cr>", { desc = "Decrease Window Width" })
map({ "n", "x", "i" }, "<C-S-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase Window Width" })

-- Add moving between windows
map("n", "<leader>w<Right>", "<cmd>wincmd l<CR>")
map("n", "<leader>w<Left>", "<cmd>wincmd h<CR>")
map("n", "<leader>w<Up>", "<cmd>wincmd k<CR>")
map("n", "<leader>w<Down>", "<cmd>wincmd j<CR>")

-- Move Lines
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- -- Jump to the next empty line or block
map("n", "<C-Up>", "{", { noremap = true })
map("n", "<C-Down>", "}", { noremap = true })

-- Buffer management
map("n", "<leader>bk", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- R to delete without putting in register
map({ "n", "x" }, "R", '"_d', { desc = "Delete Without Yank" })
