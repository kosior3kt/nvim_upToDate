return
{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require "dap"
			local ui = require "dapui"

			require("dapui").setup()

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			dap.adapters.codelldb = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "$HOME/.local/share/nvim/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			vim.keymap.set("n", "<space>d?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<leader>dc", dap.continue)
			vim.keymap.set("n", "<leader>ds", dap.step_into)
			vim.keymap.set("n", "<leader>dn", dap.step_over)
			vim.keymap.set("n", "<leader>do", dap.step_out)
			vim.keymap.set("n", "<leader>db", dap.step_back)
			vim.keymap.set("n", "<leader>dr", dap.restart)

			vim.keymap.set("n", "<leader>cb", function()
				local condition		= vim.fn.input("Condition> ")
				local hit_condition = vim.fn.input("Hit Condition> ")
				local log_message	= vim.fn.input("Log Message>")
				dap.toggle_breakpoint(condition, hit_condition, log_message)
			end)

		end
}
