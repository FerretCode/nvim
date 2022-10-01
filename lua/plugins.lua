return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'gruvbox-community/gruvbox'
	use 'windwp/nvim-autopairs'
	use 'onsails/lspkind.nvim'
	use 'ryanoasis/vim-devicons'
	use 'xiyaowong/nvim-transparent'

	use { 'Alphatechnolog/pywal.nvim', as = 'pywal' } 
	use { 'catppuccin/nvim', as = "catppuccin" }

	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons"
	}

	use {
		"nvim-treesitter/nvim-treesitter",
		run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
	}

	use {
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim"
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip"
		}
	}

	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons'
		},
		tag = 'nightly'
	}
end)
