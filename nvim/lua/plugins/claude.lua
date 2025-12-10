return {
	"coder/claudecode.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("claudecode").setup({
			-- Configuration options
			api_key = os.getenv("ANTHROPIC_API_KEY"),
		})
	end,
	keys = {
		{ "<leader>C", group = "Claude Code", mode = { "n", "v" } },
		{ "<leader>Cc", "<cmd>ClaudeCode<cr>", desc = "Open Claude", mode = "n" },
		{ "<leader>Cq", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude", mode = "n" },
		{ "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add Buffer", mode = "n" },
		{ "<leader>Cs", "<cmd>ClaudeCodeSend<cr>", desc = "Send Selection", mode = "v" },
	},
}

