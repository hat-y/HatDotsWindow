return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown", -- Load only for markdown files

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim", -- picker recomendado
	},

	opts = {
		workspaces = {
			{ name = "HatNotes", path = "~/HatNotes" },
		},

		-- Completion
		completion = {
			nvim_cmp = false, -- if you use blink.cmp, put blink = true instead of nvim_cmp
			min_chars = 2,
			create_new = true,
		},

		-- Templates & Dailies (your 0-7 structure)
		templates = {
			folder = "7-Tmpl",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},
		daily_notes = {
			folder = "3-Logs",
			date_format = "%Y-%m-%d",
			template = "log-tmpl.md",
		},

		preferred_link_style = "wiki",
		picker = { name = "telescope.nvim" },

		-- Open URLs/images on Windows
		follow_url_func = function(url)
			vim.fn.jobstart({ "cmd.exe", "/c", "start", "", url }, { detach = true })
		end,
		follow_img_func = function(img)
			vim.fn.jobstart({ "cmd.exe", "/c", "start", "", img }, { detach = true })
		end,

		sort_by = "modified",
		sort_reversed = true,
		open_notes_in = "current",

		-- Leave empty to place mappings ourselves via autocmd (more robust)
		mappings = {},
	},

	config = function(_, opts)
		-- Fallback if you accidentally removed telescope
		if opts.picker and opts.picker.name == "telescope.nvim" then
			local ok = pcall(require, "telescope")
			if not ok then
				vim.notify("[obsidian] telescope not found; using mini.pick", vim.log.levels.WARN)
				opts.picker.name = "mini.pick"
			end
		end

		require("obsidian").setup(opts)

		vim.opt.conceallevel = 1

		-- ---- Buffer-local mappings ALWAYS when buffer is markdown ----
		local function attach_obsidian_buf(bufnr)
			if not bufnr or not vim.api.nvim_buf_is_loaded(bufnr) then
				return
			end
			if vim.bo[bufnr].filetype ~= "markdown" then
				return
			end

			local ok, obs = pcall(require, "obsidian")
			if not ok then
				return
			end
			local util = obs.util

			-- gf “passthrough” oficial (README): si hay link → follow; si no → gf
			vim.keymap.set("n", "gf", function()
				return util.gf_passthrough()
			end, { buffer = bufnr, expr = true, noremap = false, silent = true, desc = "Obsidian follow (gf)" })

			-- Toggle checkbox (plugin command: most robust and doesn't depend on extra UI)
			vim.keymap.set(
				"n",
				"<leader>ch",
				"<cmd>ObsidianToggleCheckbox<CR>",
				{ buffer = bufnr, silent = true, desc = "Obsidian: toggle checkbox" }
			)

			-- Enter inteligente (seguir link / togglear / etc.)
			vim.keymap.set("n", "<CR>", function()
				return util.smart_action()
			end, { buffer = bufnr, expr = true, silent = true, desc = "Obsidian smart action" })
		end

		-- Autocmds: cuando el buffer sea markdown o entres al buffer → attach
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(ev)
				attach_obsidian_buf(ev.buf)
			end,
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function(ev)
				if vim.bo[ev.buf].filetype == "markdown" then
					attach_obsidian_buf(ev.buf)
				end
			end,
		})

		-- Immediate attach in case you're already in a note
		vim.schedule(function()
			attach_obsidian_buf(vim.api.nvim_get_current_buf())
		end)
	end,

	-- Useful shortcuts
	keys = {
		-- Plugin commands
		{ "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
		{ "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
		{ "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Daily (today)" },
		{ "<leader>oD", "<cmd>ObsidianTomorrow<cr>", desc = "Daily (tomorrow)" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Buffer links" },

		{
			"<leader>oO",
			function()
				vim.fn.jobstart({ "cmd.exe", "/c", "start", "", "obsidian://open" }, { detach = true })
			end,
			desc = "Force open Obsidian (obsidian://)",
		},
	},
}
