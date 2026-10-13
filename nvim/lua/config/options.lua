-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.maplocalleader = "<BS>"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false

-- I think I set this to hide markdown markers
vim.opt.conceallevel = 2

vim.opt.guicursor =
  "n-v-c-sm:block-blinkon750-blinkoff750-blinkwait1500,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"

if vim.g.neovide then
  vim.o.guifont = "Iosevka Nerd Font:h16"
  vim.g.neovide_cursor_smooth_blink = true

  vim.g.neovide_cursor_vfx_mode = { "pixiedust", "wireframe" }
  vim.g.neovide_cursor_vfx_particle_density = 5.0
  vim.g.neovide_cursor_vfx_particle_speed = 20.0

  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0
  vim.g.neovide_floating_corner_radius = 0.0

  vim.g.experimental_layer_grouping = false

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap("", "<C-S-V>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<C-S-V>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<C-S-V>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<C-S-V>", "<C-R>+", { noremap = true, silent = true })

  -- Dynamic UI scaling
  vim.g.neovide_scale_factor = 1.0

  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  vim.keymap.set("", "<C-ScrollWheelUp>", function()
    change_scale_factor(1.05)
  end)

  vim.keymap.set("", "<C-ScrollWheelDown>", function()
    change_scale_factor(1 / 1.05)
  end)

  -- I don't think this works but whatever
  vim.keymap.set("", "C-S-0", function()
    vim.g.neovide_scale_factor = 1
  end)

  -- attempt to get wireframe animation to trigger on large cursor jumps

  -- local last_pos = vim.api.nvim_win_get_cursor(0)
  -- local threshold = 5
  -- local animation_timer = nil
  --
  -- vim.api.nvim_create_autocmd("CursorMoved", {
  --   callback = function()
  --     local old_pos = last_pos
  --     local new_pos = vim.api.nvim_win_get_cursor(0)
  --     local line_diff = math.abs(new_pos[1] - old_pos[1])
  --
  --     if line_diff >= threshold then
  --       -- Cancel any existing timer
  --       if animation_timer then
  --         animation_timer:stop()
  --         animation_timer:close()
  --       end
  --
  --       -- Set special effect for big jump
  --       vim.g.neovide_cursor_vfx_mode = { "pixiedust", "wireframe" }
  --
  --       -- Reset after animation completes
  --       animation_timer = vim.defer_fn(function()
  --         vim.g.neovide_cursor_vfx_mode = { "pixiedust" }
  --         animation_timer = nil
  --       end, 500) -- milliseconds, match animation length
  --     end
  --
  --     last_pos = new_pos
  --   end,
  -- })
end
