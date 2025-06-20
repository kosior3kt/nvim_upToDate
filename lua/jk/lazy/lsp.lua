return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },


    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
			opts = {
				servers = {
					sourcekit = {
						cmd = "sourcekit-lsp",
					},
				},
			},
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,

						on_init = function(client)
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentFormattingRangeProvider = false
						end
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0

                end,
                pylsp = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup({
                        settings = {
                            pylsp = {
								plugins = {
									pyflakes = { enabled = false },
									pylint = { enabled = false },
									mccabe = { enabled = true },
									pycodestyle = { enabled = false },
								},
                            },
                        },
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                clangd = function()

					vim.diagnostic.config({
						-- update_in_insert = true,
						virtual_text = false,
						signs = false,
						underline = false,
						update_in_insert = false,
						float = {
							enabled = false,
							focusable = false,
							style = "minimal",
							border = "rounded",
							source = "always",
							header = "",
							prefix = "",
						},
					})

					local lspconfig = require("lspconfig")
					lspconfig.clangd.setup({

						on_attach = function(client, bufnr)
							if client.config.workspace_folders then
								local lib_dir = vim.uri_from_fname('/Users/jk/Programming/LIBRARIES/SDL/')
								table.insert(client.config.workspace_folders, { uri = lib_dir, name = lib_dir })
								client.notify("workspace/didChangeWorkspaceFolders", {
									event = "add",
									added = { { uri = lib_dir, name = lib_dir } }
								})
							end
						end,

						settings =
						{
							clangd =
							{
								diagnostics =
								{
									enabled = false
								},
                            },
                        },
                    })

                end,
            }
        })

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = {buffer = event.buf}

				vim.keymap.set('n', 'gK', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end,
		})

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-o>'] = cmp.mapping.confirm({ select = true }),
                ['<C-s>'] = cmp.mapping.complete(),
				['<C-u>'] = cmp.mapping.scroll_docs(-4),
				['<C-d>'] = cmp.mapping.scroll_docs(4),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            },
			{
					-- TODO: jk - is that correct?
                { name = 'buffer' },
            })
        })

    end
}
