-- Load config and initialize Lazy
require("config.lazy")

-- Optional modules with error handling
pcall(function()
  require("config.obsidian_maps").setup_autocmd()
end)

pcall(function()
  require("config.keymaps")
end)

pcall(function()
  require("config.dap")
end)

-- Timeout configurations
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
