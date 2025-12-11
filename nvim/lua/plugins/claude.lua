return {
	"coder/claudecode.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local api_key = os.getenv("ANTHROPIC_AUTH_TOKEN") or os.getenv("ANTHROPIC_API_KEY")
		local base_url = os.getenv("ANTHROPIC_BASE_URL") or "https://api.z.ai/api/anthropic"
		
		require("claudecode").setup({
			-- Configuration options for Z.ai proxy
			api_key = api_key,
			base_url = base_url,
			auto_start = false,
			-- Z.ai specific configuration
			provider = "anthropic",
			model = "claude-3-5-sonnet-20241022",
			timeout = 60000, -- 60 seconds for z.ai proxy
			max_tokens = 8096,
			-- Disable features that might cause crashes
			stream = false, -- Disable streaming to prevent connection issues
			-- UI options to prevent auto-close
			ui = {
				position = "right",
				size = {
					width = 0.4,
					height = 0.8,
				},
				border = "rounded",
				quit_on_q = false,
				focus_on_open = true,
			},
		})
	end,
	keys = {
		{ "<leader>C", group = "Claude Code", mode = { "n", "v" } },
		{ "<leader>Cc", "<cmd>ClaudeCode<cr>", desc = "Open Claude", mode = "n" },
		{ "<leader>Cq", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude", mode = "n" },
		{ "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add Buffer", mode = "n" },
		{ "<leader>Cs", "<cmd>ClaudeCodeSend<cr>", desc = "Send Selection", mode = "v" },
		{ "<leader>Ct", "<cmd>ClaudeCodeToggle<cr>", desc = "Toggle Claude", mode = "n" },
	},
}
