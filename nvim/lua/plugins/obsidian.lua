return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown", -- Load only for markdown files

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim", -- recommended picker
	},

	opts = {
		workspaces = {
			{
				name = "HatNotes",
				path = "~/HatNotes",
				overrides = {
					-- Performance limits for this specific workspace
					search_max_lines = 1000,
				},
			},
		},

		-- Completion settings
		completion = {
			nvim_cmp = false, -- if you use blink.cmp, put blink = true instead of nvim_cmp
			min_chars = 2,
			create_new = true,
		},

		-- Templates & Dailies (0-7 structure)
		templates = {
			folder = "7-Tmpl",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",

			-- Custom substitutions for better template functionality
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y-%m-%d", os.time() + 86400)
				end,
				current_day_name = function()
					local days = {"domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"}
					return days[os.date("%w")]
				end,
				underscored_date = function()
					return os.date("%Y_%m_%d")
				end,
			},
		},
		daily_notes = {
			folder = "3-Logs",
			date_format = "%Y-%m-%d",
			template = "log-tmpl.md",
		},

		preferred_link_style = "wiki",
		picker = { name = "telescope.nvim" },

		-- Link handling and formatting
		wiki_link_func = function(opts)
			return require("obsidian.util").wiki_link_id_prefix(opts)
		end,
		file_extension = "md",

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

		-- Performance optimizations
		ui = {
			enable = true,
			update_debounce = 200,
			max_file_length = 5000,
		},

		-- Event callbacks for enhanced functionality
		callbacks = {
			enter_note = function(note)
				-- Custom logic when entering a note can go here
				-- Example: Auto-add tags, set metadata, etc.
			end,
		},

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

		-- Buffer-local mappings when buffer is markdown
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

			-- gf "passthrough" official: if link exists -> follow; if not -> gf
			vim.keymap.set("n", "gf", function()
				return util.gf_passthrough()
			end, { buffer = bufnr, expr = true, noremap = false, silent = true, desc = "Obsidian follow (gf)" })

			-- Toggle checkbox
			vim.keymap.set(
				"n",
				"<leader>ch",
				"<cmd>ObsidianToggleCheckbox<cr>",
				{ buffer = bufnr, silent = true, desc = "Obsidian: toggle checkbox" }
			)

			-- Smart enter (follow link / toggle etc)
			vim.keymap.set("n", "<CR>", function()
				return util.smart_action()
			end, { buffer = bufnr, expr = true, silent = true, desc = "Obsidian smart action" })
		end

		-- Autocmd: when buffer is markdown or enter buffer -> attach
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(ev)
				attach_obsidian_buf(ev.buf)
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
		{ "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },

		{
			"<leader>oO",
			function()
				vim.fn.jobstart({ "cmd.exe", "/c", "start", "", "obsidian://open" }, { detach = true })
			end,
			desc = "Force open Obsidian (obsidian://)",
		},
	},
}
