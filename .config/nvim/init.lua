-- Options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.list = true
vim.opt.listchars = {
	space = "⋅",
	tab = "> ",
	trail = "•",
}

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.showmatch = true

vim.opt.number = true

vim.opt.scrolloff = 5

vim.opt.virtualedit = "block"

vim.opt.swapfile = false

vim.opt.termguicolors = true

vim.opt.clipboard:append("unnamedplus")

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set({ "n", "x" }, "<Leader>", "<Nop>")
vim.keymap.set({ "n", "x" }, "<Plug>(_LSP)", "<Nop>")
vim.keymap.set({ "n", "x" }, ",", "<Plug>(_LSP)")
vim.keymap.set({ "n", "x" }, "<Plug>(_FuzzyFinder)", "<Nop>")
vim.keymap.set({ "n", "x" }, "z", "<Plug>(_FuzzyFinder)")

vim.keymap.set("n", "<Leader>L", [[<Cmd>Lazy<CR>]])

vim.keymap.set({ "n", "x" }, ";", ":")
vim.keymap.set({ "n", "x" }, ":", ";")

vim.keymap.set("n", "<Leader>w", [[<Cmd>update<CR>]])
vim.keymap.set("n", "<Leader>q", [[<Cmd>quit<CR>]])

vim.keymap.set({ "n", "x" }, "<Leader>h", "^")
vim.keymap.set({ "n", "x" }, "<Leader>l", "$")

vim.keymap.set("n", "<ESC><ESC>", [[<Cmd>nohlsearch<CR>]])

vim.keymap.set("n", "<Left>", [[<Cmd>vertical resize -5<CR>]])
vim.keymap.set("n", "<Right>", [[<Cmd>vertical resize +5<CR>]])
vim.keymap.set("n", "<Up>", [[<Cmd>resize -5<CR>]])
vim.keymap.set("n", "<Down>", [[<Cmd>resize +5<CR>]])

vim.keymap.set("n", "ZZ", "<Nop>")
vim.keymap.set("n", "ZQ", "<Nop>")

-- FileType
local ft_settings = {
	go = {
		tabstop = 4,
		shiftwidth = 4,
		expandtab = false,
	},
	lua = {
		tabstop = 4,
		shiftwidth = 4,
		expandtab = false,
	},
	python = {
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
	},
	rust = {
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
	},
	java = {
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
	},
}
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		local s = ft_settings[vim.bo.filetype]
		if s then
			vim.opt_local.tabstop = s.tabstop
			vim.opt_local.shiftwidth = s.shiftwidth
			vim.opt_local.expandtab = s.expandtab
		end
	end,
})

-- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- Utils
local diagnostic_icons = {
	hint = "󰌵",
	info = " ",
	warn = " ",
	error = " ",
}

-- Diagnostic
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		virtual_text = false,
		text = {
			[vim.diagnostic.severity.HINT] = diagnostic_icons.hint,
			[vim.diagnostic.severity.INFO] = diagnostic_icons.info,
			[vim.diagnostic.severity.WARN] = diagnostic_icons.warn,
			[vim.diagnostic.severity.ERROR] = diagnostic_icons.error,
		},
	},
})

-- Custom Commands
vim.api.nvim_create_user_command("ChownSelf", function()
	local uid = vim.fn.system("id -u"):gsub("\n$", "")
	local gid = vim.fn.system("id -g"):gsub("\n$", "")
	local current_file = vim.fn.expand("%:p")
	local command = string.format("!sudo chown -R %s:%s %s", uid, gid, vim.fn.shellescape(current_file))
	vim.cmd(command)
end, {})

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
end, {})

-- Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	defaults = {
		lazy = true,
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
	spec = {
		-- Completion
		{
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-cmdline",
				"saadparwaiz1/cmp_luasnip",
				"L3MON4D3/LuaSnip",
				"onsails/lspkind-nvim",
			},
			config = function()
				local cmp = require("cmp")
				local lspkind = require("lspkind")
				local luasnip = require("luasnip")
				cmp.setup({
					mapping = cmp.mapping.preset.insert({
						["<C-u>"] = cmp.mapping.scroll_docs(-4),
						["<C-d>"] = cmp.mapping.scroll_docs(4),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "path" },
						{ name = "nvim_lsp_signature_help" },
						{ name = "nvim_lua" },
						{ name = "luasnip" },
					}, {
						{ name = "buffer" },
					}),
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					formatting = {
						format = lspkind.cmp_format({
							mode = "symbol_text",
							maxwidth = {
								menu = 50,
								abbr = 50,
							},
							ellipsis_char = "...",
							show_labelDetails = true,
						}),
					},
				})
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "cmdline" },
						{ name = "path" },
					}),
				})
				cmp.setup.cmdline("/", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "nvim_lsp_document_symbol" },
						{ name = "buffer" },
					}),
				})
			end,
		},
		-- LSP
		{
			"williamboman/mason.nvim",
			cmd = "Mason",
			config = true,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local lspconfig = require("lspconfig")
				local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
				local on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
							end,
						})
					end
				end
				lspconfig.solargraph.setup({
					capabilities = default_capabilities,
					on_attach = on_attach,
				})
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				"neovim/nvim-lspconfig",
				"hrsh7th/cmp-nvim-lsp",
			},
			event = { "BufReadPre", "BufNewfile" },
			config = function()
				local mason_lspconfig = require("mason-lspconfig")
				local lspconfig = require("lspconfig")
				local ensure_installed = {
					"jdtls",
					"lua_ls",
					"rust_analyzer",
					"terraformls",
				}
				if vim.fn.executable("cargo") == 1 then
					table.insert(ensure_installed, "asm_lsp")
				end
				if vim.fn.executable("gem") == 1 then
					table.insert(ensure_installed, "solargraph")
				end
				if vim.fn.executable("go") == 1 then
					table.insert(ensure_installed, "gopls")
				end
				if vim.fn.executable("npm") == 1 then
					table.insert(ensure_installed, "cssls")
					table.insert(ensure_installed, "dockerls")
					table.insert(ensure_installed, "eslint")
					table.insert(ensure_installed, "html")
					table.insert(ensure_installed, "pyright")
					table.insert(ensure_installed, "ts_ls")
				end
				if vim.fn.executable("python3") == 1 then
					table.insert(ensure_installed, "cmake")
				end
				mason_lspconfig.setup({
					ensure_installed = ensure_installed,
					automatic_installation = true,
				})
				local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
				local on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end
				mason_lspconfig.setup_handlers({
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = default_capabilities,
							on_attach = on_attach,
						})
					end,
					["cssls"] = function()
						lspconfig.cssls.setup({
							capabilities = default_capabilities,
							on_attach = function(client, bufnr)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
								on_attach(client, bufnr)
							end,
						})
					end,
					["html"] = function()
						lspconfig.html.setup({
							capabilities = default_capabilities,
							on_attach = function(client, bufnr)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
								on_attach(client, bufnr)
							end,
						})
					end,
					["jdtls"] = function()
						return true
					end,
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = default_capabilities,
							on_attach = function(client, bufnr)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
								on_attach(client, bufnr)
							end,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" },
									},
								},
							},
						})
					end,
					["pyright"] = function()
						lspconfig.pyright.setup({
							capabilities = default_capabilities,
							on_attach = on_attach,
							settings = {
								python = {
									venvPath = ".",
									pythonPath = "./.venv/bin/python",
									analysis = {
										extraPaths = { "." },
									},
								},
							},
						})
					end,
					["rust_analyzer"] = function()
						lspconfig.rust_analyzer.setup({
							capabilities = default_capabilities,
							on_attach = on_attach,
							settings = {
								["rust-analyzer"] = {
									checkOnSave = {
										command = "clippy",
									},
								},
							},
						})
					end,
					["ts_ls"] = function()
						lspconfig.ts_ls.setup({
							capabilities = default_capabilities,
							init_options = {
								preferences = {
									importModuleSpecifierPreference = "non-relative",
								},
							},
							on_attach = function(client, bufnr)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
								on_attach(client, bufnr)
							end,
						})
					end,
				})
			end,
		},
		{
			"jay-babu/mason-null-ls.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				{
					"nvimtools/none-ls.nvim",
					dependencies = {
						"nvim-lua/plenary.nvim",
						"nvimtools/none-ls-extras.nvim",
					},
				},
			},
			event = { "BufReadPre", "BufNewfile" },
			config = function()
				local mason_null_ls = require("mason-null-ls")
				local null_ls = require("null-ls")
				local ensure_installed = {
					"asmfmt",
					"checkmake",
					"shfmt",
					"stylua",
				}
				local sources = {
					null_ls.builtins.formatting.asmfmt,
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.formatting.shfmt.with({
						filetypes = { "sh", "zsh" },
					}),
					null_ls.builtins.formatting.stylua,
				}
				if vim.fn.executable("npm") == 1 then
					table.insert(ensure_installed, "prettier")
					table.insert(sources, null_ls.builtins.formatting.prettier)
				end
				if vim.fn.executable("python3") == 1 then
					table.insert(ensure_installed, "black")
					table.insert(ensure_installed, "isort")
					table.insert(ensure_installed, "flake8")
					table.insert(sources, null_ls.builtins.formatting.black)
					table.insert(sources, null_ls.builtins.formatting.isort)
					table.insert(sources, require("none-ls.diagnostics.flake8"))
				end
				mason_null_ls.setup({
					ensure_installed = ensure_installed,
					automatic_installation = true,
				})
				null_ls.setup({
					sources = sources,
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ async = false })
								end,
							})
						end
					end,
				})
			end,
		},
		{
			"nvimdev/lspsaga.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
			event = { "VeryLazy" },
			config = function()
				require("lspsaga").setup({
					lightbulb = {
						enable = false,
					},
					symbol_in_winbar = {
						enable = false,
					},
				})
				vim.keymap.set({ "n" }, "<Plug>(_LSP)K", "<Cmd>Lspsaga hover_doc<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)d", "<Cmd>Lspsaga peek_definition<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)D", "<Cmd>Lspsaga goto_definition<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)f", "<Cmd>Lspsaga finder<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)e", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)o", "<Cmd>Lspsaga outline<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)r", "<Cmd>Lspsaga rename ++project<CR>")
				vim.keymap.set({ "n" }, "<Plug>(_LSP)c", "<Cmd>Lspsaga code_action<CR>")
			end,
		},
		{
			"j-hui/fidget.nvim",
			event = { "BufReadPre", "BufNewfile" },
			config = true,
		},
		{
			"mfussenegger/nvim-jdtls",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
			},
			ft = { "java" },
			-- ref: https://github.com/dragove/nvim/blob/b8e548ab397687bfc0d8528f900f91212ec03651/lua/plugins/jdtls.lua
			config = function()
				local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
				local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
				local config = {
					cmd = { install_path .. "/bin/jdtls" },
					capabilities = default_capabilities,
					root_dir = vim.fs.dirname(
						vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
					),
				}
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "java",
					callback = function()
						require("jdtls").start_or_attach(config)
					end,
				})
			end,
		},
		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			dependencies = {
				"nvim-treesitter/playground",
				"RRethy/nvim-treesitter-endwise",
			},
			event = { "VeryLazy" },
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = {
						"asm",
						"bash",
						"c",
						"cmake",
						"cpp",
						"css",
						"dockerfile",
						"git_config",
						"gitcommit",
						"gitignore",
						"go",
						"gomod",
						"graphql",
						"groovy",
						"html",
						"java",
						"json",
						"lua",
						"make",
						"markdown",
						"nginx",
						"prisma",
						"proto",
						"python",
						"rbs",
						"ruby",
						"rust",
						"slim",
						"sql",
						"ssh_config",
						"starlark",
						"terraform",
						"tmux",
						"toml",
						"tsx",
						"typescript",
						"xml",
						"yaml",
					},
					sync_install = false,
					highlight = {
						enable = true,
					},
					incremental_selection = {
						enable = true,
						keymaps = {
							node_incremental = "<CR>",
							node_decremental = "<S-CR>",
						},
					},
					endwise = {
						enable = true,
					},
				})
				vim.treesitter.language.register("bash", "zsh")
			end,
		},
		-- FuzzyFinder
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
				},
				{
					"nvim-telescope/telescope-live-grep-args.nvim",
				},
				"crispgm/telescope-heading.nvim",
			},
			event = { "VimEnter" },
			config = function()
				local telescope = require("telescope")
				local lga_actions = require("telescope-live-grep-args.actions")
				telescope.setup({
					extensions = {
						live_grep_args = {
							auto_quoting = true,
							mappings = {
								i = {
									["<C-k>"] = lga_actions.quote_prompt(),
								},
							},
						},
						heading = {
							treesitter = true,
						},
					},
				})
				telescope.load_extension("fzf")
				telescope.load_extension("live_grep_args")
				telescope.load_extension("heading")
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)f", [[<Cmd>Telescope find_files<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)o", [[<Cmd>Telescope oldfiles<CR>]])
				vim.keymap.set(
					"n",
					"<Plug>(_FuzzyFinder)s",
					[[<Cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]]
				)
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)b", [[<Cmd>Telescope buffers<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder);", [[<Cmd>Telescope command_history<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)/", [[<Cmd>Telescope search_history<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)q", [[<Cmd>Telescope quickfix<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)d", [[<Cmd>Telescope diagnostics<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)n", [[<Cmd>Telescope notify<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)g", [[<Cmd>Telescope git_status<CR>]])
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)h", [[<Cmd>Telescope heading<CR>]])
			end,
		},
		-- Filer
		{
			"nvim-neo-tree/neo-tree.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			event = { "VimEnter" },
			opts = {
				close_if_last_window = true,
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true,
					},
					group_empty_dirs = true,
				},
				default_component_configs = {
					diagnostics = {
						symbols = {
							hint = diagnostic_icons.hint,
							info = diagnostic_icons.info,
							warn = diagnostic_icons.warn,
							error = diagnostic_icons.error,
						},
					},
				},
			},
			init = function()
				vim.keymap.set({ "n" }, "<C-n>", [[<Cmd>Neotree toggle reveal<CR>]])
			end,
		},
		-- Diagnostic
		{
			"folke/trouble.nvim",
			cmd = "Trouble",
			keys = {
				{
					"<Leader>xx",
					[[<Cmd>Trouble diagnostics toggle<CR>]],
					mode = { "n" },
				},
				{
					"<leader>xX",
					[[<Cmd>Trouble diagnostics toggle filter.buf=0<CR>]],
					mode = { "n" },
				},
			},
			opts = {
				focus = true,
				open_no_results = true,
			},
		},
		-- AI
		-- Nodejs is required.
		-- First, execute `Copilot auth`.
		{
			"zbirenbaum/copilot.lua",
			event = { "InsertEnter" },
			opts = {
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<Tab>",
					},
				},
			},
		},
		-- Git
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim",
			},
			keys = {
				{
					"<Leader>g",
					[[<Cmd>Neogit<CR>]],
					mode = { "n" },
				},
			},
			config = true,
		},
		{
			"lewis6991/gitsigns.nvim",
			event = { "VeryLazy" },
			config = true,
		},
		-- Cmdline
		{
			"folke/noice.nvim",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			event = { "VimEnter" },
			opts = {
				popupmenu = {
					backend = "cmp",
				},
			},
		},
		-- Terminal
		{
			"akinsho/toggleterm.nvim",
			cmd = "ToggleTerm",
			config = true,
		},
		-- Sinippet
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			build = "make install_jsregexp",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load({
					paths = {
						vim.fn.stdpath("data") .. "/lazy/friendly-snippets",
					},
				})
				local luasnip = require("luasnip")
				vim.keymap.set({ "i", "s" }, "<C-L>", function()
					luasnip.jump(1)
				end)
				vim.keymap.set({ "i", "s" }, "<C-J>", function()
					luasnip.jump(-1)
				end)
			end,
		},
		-- View
		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			event = { "VimEnter" },
			config = true,
		},
		-- Bufferline
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			event = { "BufReadPre", "BufNewfile" },
			config = function()
				require("bufferline").setup({
					options = {
						diagnostics = "nvim_lsp",
						offsets = {
							{
								filetype = "neo-tree",
								text = "FileExplorer",
								text_align = "center",
								separator = true,
							},
						},
						separator_style = "slant",
					},
				})
				vim.keymap.set({ "n" }, "<C-b>l", "<Cmd>BufferLineCycleNext<CR>")
				vim.keymap.set({ "n" }, "<C-b>h", "<Cmd>BufferLineCyclePrev<CR>")
			end,
		},
		{
			"petertriho/nvim-scrollbar",
			event = { "VeryLazy" },
			config = true,
		},
		-- Startup
		{
			"goolord/alpha-nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			event = { "VimEnter" },
			config = function()
				local startify = require("alpha.themes.startify")
				startify.file_icons.provider = "devicons"
				startify.section.header.val = {
					[[                                                                       ]],
					[[  ██████   █████                   █████   █████  ███                  ]],
					[[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
					[[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
					[[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
					[[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
					[[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
					[[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
					[[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
					[[                                                                       ]],
				}
				require("alpha").setup(startify.config)
			end,
		},
		-- Edit
		{
			"kylechui/nvim-surround",
			event = { "VeryLazy" },
			config = true,
		},
		{
			"gbprod/substitute.nvim",
			keys = {
				{
					"_",
					[[<Cmd>lua require('substitute').operator()<CR>]],
					mode = { "n", "x" },
				},
			},
			config = true,
		},
		{
			"mopp/vim-operator-convert-case",
			dependencies = {
				"kana/vim-operator-user",
			},
			keys = {
				{
					"<Leader>cl",
					"<Plug>(operator-convert-case-lower-camel)",
					mode = { "n", "x" },
				},
				{
					"<Leader>cu",
					"<Plug>(operator-convert-case-upper-camel)",
					mode = { "n", "x" },
				},
				{
					"<Leader>sl",
					"<Plug>(operator-convert-case-lower-snake)",
					mode = { "n", "x" },
				},
				{
					"<Leader>su",
					"<Plug>(operator-convert-case-upper-snake)",
					mode = { "n", "x" },
				},
			},
		},
		{
			"windwp/nvim-autopairs",
			event = { "InsertEnter" },
			config = true,
		},
		{
			"windwp/nvim-ts-autotag",
			event = { "InsertEnter" },
			config = true,
		},
		{
			"Wansmer/treesj",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			keys = {
				{
					"<Leader>t",
					[[<Cmd>lua require('treesj').toggle()<CR>]],
					mode = { "n" },
				},
			},
			opts = {
				use_default_keymaps = false,
			},
		},
		{
			"monaqa/dial.nvim",
			keys = {
				{
					"+",
					[[<Plug>(dial-increment)]],
					mode = { "n", "x" },
				},
				{
					"-",
					[[<Plug>(dial-decrement)]],
					mode = { "n", "x" },
				},
			},
		},
		{
			"numToStr/Comment.nvim",
			dependencies = {
				{
					"JoosepAlviste/nvim-ts-context-commentstring",
					dependencies = { "nvim-treesitter/nvim-treesitter" },
					opts = {
						enable_autocmd = false,
					},
				},
			},
			event = { "VeryLazy" },
			config = function()
				require("Comment").setup({
					pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				})
			end,
		},
		-- Search
		{
			"kevinhwang91/nvim-hlslens",
			keys = {
				{
					"<Leader>/",
					[[*<Cmd>lua require('hlslens').start()<CR>]],
					mode = { "n" },
				},
			},
			config = true,
		},
		-- Move
		{
			"smoka7/hop.nvim",
			keys = {
				{
					"<Leader>f",
					[[<Cmd>lua require('hop').hint_words()<CR>]],
					mode = { "n", "x" },
					remap = true,
				},
			},
			opts = {
				keys = "etovxqpdygfblzhckisuran",
			},
		},
		-- Highlight
		{
			"mvllow/modes.nvim",
			event = { "VeryLazy" },
			config = true,
		},
		{
			"folke/todo-comments.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
			event = { "VeryLazy" },
			config = function()
				require("todo-comments").setup({})
				vim.keymap.set("n", "<Plug>(_FuzzyFinder)t", [[<Cmd>TodoTelescope<CR>]])
				vim.keymap.set("n", "qt", [[<Cmd>TodoQuickFix<CR>]])
			end,
		},
		{
			"norcalli/nvim-colorizer.lua",
			event = { "VeryLazy" },
			config = function()
				require("colorizer").setup()
			end,
		},
		-- Jump
		{
			"rgroli/other.nvim",
			cmd = "Other",
			config = function()
				require("other-nvim").setup({
					mappings = {
						"rails",
					},
				})
			end,
		},
		-- Quickfix
		{
			"kevinhwang91/nvim-bqf",
			ft = { "qf" },
			config = true,
		},
		{
			"gabrielpoca/replacer.nvim",
			ft = { "qf" },
			config = function()
				require("replacer").setup()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "qf",
					callback = function()
						local opts = { save_on_write = false, rename_files = false }
						vim.keymap.set("n", "<leader>r", function()
							require("replacer").run(opts)
						end, { buffer = true })
						vim.keymap.set("n", "<leader>w", function()
							require("replacer").save(opts)
						end, { buffer = true })
					end,
				})
			end,
		},
		-- Lastplace
		{
			"farmergreg/vim-lastplace",
			event = { "BufReadPre" },
		},
		-- Notification
		{
			"rcarriga/nvim-notify",
			event = { "VeryLazy" },
			config = function()
				local notify = require("notify")
				notify.setup({
					background_colour = "#282828",
				})
				vim.notify = notify
			end,
			enabled = false,
		},
		-- Colorscheme
		{
			"ellisonleao/gruvbox.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.o.background = "dark"
				vim.cmd.colorscheme("gruvbox")
			end,
		},
	},
})
