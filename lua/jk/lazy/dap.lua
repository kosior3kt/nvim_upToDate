return
{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
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

			vim.keymap.set("n", "<space>db", dap.toggle_breakpoint, {desc = "toggle breakpoint"})
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor, {desc = "run tu cursor"})

			dap.adapters.codelldb = {
				type = "server",
				-- host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "codelldb",
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
			end, {desc = "toggle debug ui"})

			vim.keymap.set("n", "<leader>dc", dap.continue, {desc = "continue"})
			vim.keymap.set("n", "<leader>ds", dap.step_into, {desc = "step into"})
			vim.keymap.set("n", "<leader>dn", dap.step_over, {desc = "step over"})
			vim.keymap.set("n", "<leader>do", dap.step_out, {desc = "step out"})
			vim.keymap.set("n", "<leader>db", dap.step_back, {desc = "step back"})
			vim.keymap.set("n", "<leader>dr", dap.restart, {desc = "restart"})

			vim.keymap.set("n", "<leader>dcb", function()
				local condition		= vim.fn.input("Condition> ")
				local hit_condition = vim.fn.input("Hit Condition> ")
				local log_message	= vim.fn.input("Log Message>")
				dap.toggle_breakpoint(condition, hit_condition, log_message)
			end, {desc = "conditional breakpoint"})

		end
}
