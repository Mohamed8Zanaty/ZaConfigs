return {
	"neovim/nvim-lspconfig",  -- Keep for compatibility, but we'll use vim.lsp.config
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp"
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap
		
		local opts = { noremap = true, silent = true }

		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Show LSP Definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
		end

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure clangd
		vim.lsp.config.clangd = {
			cmd = { "clangd", "--completion-style=detailed" },
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
		}

		-- Configure lua_ls
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },  -- Fixed typo: 'gloabls' -> 'globals'
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		}

		-- Configure pyright
		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
		}

		-- Configure texlab
		vim.lsp.config.texlab = {
			cmd = { "texlab" },
			filetypes = { "tex", "bib" },
			root_markers = { ".git", "latexmkrc", "texlabroot" },
			capabilities = capabilities,
			on_attach = on_attach,
		}

		-- Enable the LSP servers for all buffers
		vim.lsp.enable("clangd")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("pyright")
		vim.lsp.enable("texlab")
	end,
}
