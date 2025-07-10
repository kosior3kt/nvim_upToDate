return
{
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

	config = function()

		require('telescope').setup({

			defaults = {
				-- layout_strategy = 'vertical', -- or 'horizontal' (but 'vertical' gives more space)
				layout_config = {
					vertical = {
						width = 0.95,        -- Use 95% of the screen width
						height = 0.95,        -- Use 95% of the screen height
						preview_height = 0.7, -- Preview takes 70% of Telescope's height
						prompt_position = "top", -- Optional: keeps input at the top
						preview_cutoff = 1,   -- Never hide preview
					},
					horizontal = {          -- Alternative if you prefer horizontal
						width = 0.95,
						height = 0.95,
						preview_width = 0.7,  -- Preview takes 70% of Telescope's width
						preview_cutoff = 1,   -- Never hide preview (0 = disable, 1 = always show)
					},
				},
			},
		})

        local builtin = require('telescope.builtin')
        local utils = require('telescope.utils')
		local action_state = require('telescope.actions.state')
		local actions = require('telescope.actions')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "open file picker"})
        vim.keymap.set('n', '<leader>fg', builtin.git_files, {desc = "open git files"})
        vim.keymap.set('n', '<leader>ft', builtin.tags, {desc = "open tag list"})
        vim.keymap.set('n', '<leader>f\"', builtin.registers, {desc = "open register list"})
        vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {desc = "open lsp references"})
        vim.keymap.set('n', '<leader>fm', builtin.marks, {desc = "open mark list"})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {desc = "open help tags"})
		vim.keymap.set('n', '<leader>fs', builtin.live_grep, {desc = "grep"})
		vim.keymap.set('n', '<leader>fj', builtin.jumplist, {desc = "open jumplist"})

        vim.keymap.set('n', '<leader>fw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc = "grep same word"})

        vim.keymap.set('n', '<leader>fat', function()
			vim.cmd[[normal! viw"+y]]
            builtin.tags()
        end)
        vim.keymap.set('n', '<leader>fW', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, {desc = "grep same word"})
        -- vim.keymap.set('n', '<leader>fs', function()
        --     builtin.grep_string({ search = vim.fn.input("Grep > ") })
        -- end)



		Buffer_searcher = function()
			builtin.buffers {
				sort_mru = true,
				ignore_current_buffer = true,
				show_all_buffers = false,
				attach_mappings = function(prompt_bufnr, map)
					local refresh_buffer_searcher = function()
						actions.close(prompt_bufnr)
						vim.schedule(Buffer_searcher)
					end

					local delete_buf = function()
						local selection = action_state.get_selected_entry()
						vim.api.nvim_buf_delete(selection.bufnr, { force = true })
						refresh_buffer_searcher()
					end

					local delete_multiple_buf = function()
						local picker = action_state.get_current_picker(prompt_bufnr)
						local selection = picker:get_multi_selection()
						for _, entry in ipairs(selection) do
							vim.api.nvim_buf_delete(entry.bufnr, { force = true })
						end
						refresh_buffer_searcher()
					end

					map('n', 'dd', delete_buf)
					map('n', '<C-d>', delete_multiple_buf)
					map('i', '<C-d>', delete_multiple_buf)

					return true
				end
			}
		end

		vim.keymap.set('n', '<leader>fb', Buffer_searcher, {})


		-- local
		vim.keymap.set('n', '<leader>lf', function()
			builtin.find_files({cwd = utils.buffer_dir()})
		end, {desc = "looks for files relative to current buffer"})

    end
}

