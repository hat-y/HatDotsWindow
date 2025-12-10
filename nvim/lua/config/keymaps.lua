-- Optimized keymaps configuration to avoid conflicts

local utils = require("config.utils")

-- Use utils.map for all mappings
local map = utils.map

-- ====================================================================
-- which-key - organization of groups
-- ====================================================================

-- Movement and navigation (without conflicts)
map("n", "J", "mzJ`z", { desc = "Join line below" })
map("n", "K", "mzK`z", { desc = "Join line above" })

-- window movement (direct alternative)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Restore and configure Ctrl+w for window navigation
-- Configure Ctrl+w as prefix for window commands
vim.keymap.set("n", "<C-w>h", "<C-w>h", { noremap = true, silent = true, desc = "Window left" })
vim.keymap.set("n", "<C-w>j", "<C-w>j", { noremap = true, silent = true, desc = "Window down" })
vim.keymap.set("n", "<C-w>k", "<C-w>k", { noremap = true, silent = true, desc = "Window up" })
vim.keymap.set("n", "<C-w>l", "<C-w>l", { noremap = true, silent = true, desc = "Window right" })
vim.keymap.set("n", "<C-w>q", "<C-w>q", { noremap = true, silent = true, desc = "Quit window" })
vim.keymap.set("n", "<C-w>v", "<C-w>v", { noremap = true, silent = true, desc = "Split vertical" })
vim.keymap.set("n", "<C-w>-", "<C-w>-", { noremap = true, silent = true, desc = "Split horizontal" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ====================================================================
-- Organized leader key groups
-- ====================================================================

-- Buffer operations
map("n", "<leader>b", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- File operations
-- Groups will be defined with which-key at the end of the file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- Search
map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep in project" })
map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in buffer" })

-- Quick access
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- ====================================================================
-- Claude Code - Move to <leader>a (AI)
-- ====================================================================

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
map("n", "<leader>at", "<cmd>ClaudeCodeContinue<cr>", { desc = "Continue recent conversation" })
map("n", "<leader>av", "<cmd>ClaudeCodeVerbose<cr>", { desc = "Verbose logging" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })

-- Diff management
map("n", "<leader>da", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>dd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- ====================================================================
-- LSP - Use <leader>l instead of <Space>c for code
-- ====================================================================

map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format buffer" })
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostics" })
map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })

-- ====================================================================
-- Terminal
-- ====================================================================

map("n", "<leader>tt", "<cmd>toggleterm<cr>", { desc = "Toggle terminal" })
map("n", "<leader>tn", "<cmd>toggleterm<cr>", { desc = "New terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ====================================================================
-- Debugging (DAP) - Keep LazyVim defaults
-- ====================================================================

-- DAP shortcuts are already configured by LazyVim:
-- <F5>: Continue
-- <F10>: Step over
-- <F11>: Step into
-- <F9>: Toggle breakpoint

-- ====================================================================
-- Utilities
-- ====================================================================

-- Clear highlight on escape
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Note: which-key configuration is managed through individual plugins
-- Groups are automatically defined through keymap descriptions
