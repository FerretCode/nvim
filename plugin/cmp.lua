local cmp = require("cmp")

local kind_icons = {
  Text = "﫦",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "全",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{
			name = "nvim_lsp",
			entry_filter = function(entry, ctx)
				return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
			end
		},
		{ name = 'vsnip' },
	}, {
		{
			name = 'buffer',
			entry_filter = function(entry, ctx)
				return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
			end
		}
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" }, 
		format = function (entry, vim_item)
			local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. strings[1] .. " "
      kind.menu = "    (" .. strings[2] .. ")"

      return kind
		end
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	}
})

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig")["sumneko_lua"].setup {
	capabilities = capabilities
}

require("lspconfig")["gopls"].setup {
	capabilities = capabilities
}

require("lspconfig")["tsserver"].setup {
	capabilities = capabilities
}

require("lspconfig")["rust_analyzer"].setup {
	capabilities = capabilities
}

require("lspconfig")["nimls"].setup {
	capabilities = capabilities
}

require("lspconfig")["pylsp"].setup {
	capabilities = capabilities
}

require("lspconfig")["nimls"].setup {
	capabilities = capabilities
}

require("lspconfig")["rust_analyzer"].setup {
	capabilities = capabilities
}
