-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- systemd lsp
-- Automatically set filetype and start LSP for specific systemd unit file patterns
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.service", "*.mount", "*.device", "*.nspawn", "*.target", "*.timer" },
  callback = function()
    vim.bo.filetype = "systemd"
    vim.lsp.start({
      name = "systemd_ls",
      -- TODO: make this get the home dir programatically
      cmd = { "/home/aarchangel/.cargo/bin/systemd-lsp" }, -- Update this path to your systemd-lsp binary
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- I forget why I did this but probably because docker-compose.yml wasn't being picked up vs docker-compose.yaml
local function set_filetype(pattern, filetype)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = pattern,
    command = "set filetype=" .. filetype,
  })
end

set_filetype({ "docker-compose.yml" }, "yaml.docker-compose")

-- Automatically reload files from disk if they change. Mainly useful to use both nvim and Pluto.jl together.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_autocmd(
  { "FileChangedShellPost" },
  { command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None', pattern = { "*" } }
)
