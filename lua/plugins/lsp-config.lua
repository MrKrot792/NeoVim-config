return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"onsails/lspkind.nvim",
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd" },
				automatic_installation = true, -- Автоматическая установка LSP
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Явно указываем зависимость
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local lspconfig = require("lspconfig")

			-- Общие настройки для всех LSP
			local common_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local common_on_attach = function(client, bufnr)
				-- Общие keymaps и autocmd
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
				vim.keymap.set("n", "<leader>ff", function()
					vim.lsp.buf.format({ async = true })
				end, { buffer = bufnr })
			end

			-- Автоматическая настройка LSP серверов из Mason
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = common_capabilities,
						on_attach = common_on_attach,
					})
				end,
				-- Специфичные настройки для отдельных LSP
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = common_capabilities,
						on_attach = common_on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["clangd"] = function()
					lspconfig.clangd.setup({
						cmd = { "clangd", "--fallback-style=Microsoft" },
						capabilities = common_capabilities,
						on_attach = common_on_attach,
					})
				end,
			})

			-- Настройка cmp
			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
			})
		end,
	},
}
