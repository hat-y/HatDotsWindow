return {
	-- Markdown Preview (Reading Mode)
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- Configuration for markdown preview
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				-- sync_scroll_type = "middle",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
				content_editable = false,
				disable_filename = 0,
				toc = {},
			}
			vim.g.mkdp_page_title = "${name}"
			vim.g.mkdp_theme = "dark"
		end,
	},

	-- Telescope Media Files for media preview
	{
		"nvim-telescope/telescope-media-files.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("media_files")
			vim.keymap.set("n", "<leader>fp", function()
				require("telescope").extensions.media_files.media_files()
			end, { desc = "Preview media files" })
		end,
	},

	-- Markdown Commenting
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		keys = { "gc", "gcc", "gbc" },
		config = function()
			require("Comment").setup({
				toggler = {
					line = "gcc",
					block = "gbc",
				},
				padding = true,
				sticky = true,
				keys = {
					comment = "gc",
					ecomment = "gc",
					multiline_comment = "gbc",
				},
			})
		end,
	},
}
