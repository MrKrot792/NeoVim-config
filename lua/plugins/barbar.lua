return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		vim.keymap.set("n", "<leader>l", ":BufferNext<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>h", ":BufferPrevious<CR>", { silent = true }),
		vim.keymap.set("n", "<leader>q", ":BufferClose<CR>", { silent = true }),
	},
	version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
