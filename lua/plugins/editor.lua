return {
    { "folke/flash.nvim" },
    { "folke/trouble.nvim" },
    { "tjdevries/vlog.nvim" },
    {
        "stevearc/conform.nvim",
        dependencies = { "mason.nvim" },
        lazy = true,
        cmd = "ConformInfo",
        opts = function()
            local opts = {
                default_format_opts = {
                    timeout_ms = 3000,
                    async = false,
                    quiet = false,
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    proto = {},
                },
                formatters = {
                    stylua = {
                        prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                    },
                    prettier = {
                        args = function(ctx)
                            return { "--tab-width", "4", "--parser", "babel", ctx.filename }
                        end,
                    },
                },
            }

            return opts
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, { name = "emoji" })
            table.insert(opts.sources, {
                {
                    name = "nvim_lsp",
                    entry_filter = function(entry, ctx)
                        local kind = types.lsp.CompletionItemKind[entry:get_kind()]

                        if kind == "Text" or kind == "Snippet" then
                            return false
                        end

                        return true
                    end,
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>r",
                "<cmd>Telescope projects<CR>",
                desc = "Recent Projects (<c-w> to chdir)",
            },
            {
                "<leader>rg",
                "<cmd>Telescope live_grep<CR>",
                desc = "grep",
            },
        },
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
            pickers = {
                live_grep = {
                    path_display = { "filename_only" },
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.9,
                        height = 0.8,
                        prompt_position = "top",
                    },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        position = "left",
                        size = 40,
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        position = "bottom",
                        size = 10,
                    },
                },
            })

            dap.adapters.coreclr = {
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
                args = { "--interpreter=vscode" },
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "Launch - Auto-detect",
                    request = "launch",
                    program = function()
                        local cwd = vim.fn.getcwd()
                        local possible_paths = {
                            cwd .. "/bin/Debug/net8.0/*.dll",
                            cwd .. "/bin/Debug/net7.0/*.dll",
                            cwd .. "/bin/Debug/net6.0/*.dll",
                            cwd .. "/*/bin/Debug/net8.0/*.dll",
                            cwd .. "/*/bin/Debug/net7.0/*.dll",
                            cwd .. "/*/bin/Debug/net6.0/*.dll",
                        }
                        for _, pattern in ipairs(possible_paths) do
                            local files = vim.fn.glob(pattern, false, true)
                            if #files > 0 then
                                return files[1]
                            end
                        end
                        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = false,
                    console = "integratedTerminal",
                },
                {
                    type = "coreclr",
                    name = "Launch - Custom",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = false,
                    console = "integratedTerminal",
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " ")
                    end,
                },
                {
                    type = "coreclr",
                    name = "Attach to Process",
                    request = "attach",
                    processId = function()
                        return require("dap.utils").pick_process({ filter = "dotnet" })
                    end,
                },
            }

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
            })
        end,
    },
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern", "lsp" },
                patterns = { ".git" },
                show_hidden = false,
                silent_chdir = true,
            })
        end,
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        dependencies = {
            "tris203/rzls.nvim",
            config = true,
        },
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            choose_target = function(targets)
                local log = require("vlog")

                log.info("these are the targets:", targets)

                local sln_target = vim.iter(targets):find(function(item)
                    return string.match(item, ".sln$")
                end)

                log.info("sln_target")

                if sln_target then
                    return sln_target
                end
            end,
        },
        config = function()
            local mason_registry = require("mason-registry")

            local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
            local cmd = {
                "roslyn",
                "--stdio",
                "--logLevel=Information",
                "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
                "--razorDesignTimePath="
                    .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
                "--extension",
                vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
            }

            vim.lsp.config("roslyn", {
                cmd = cmd,
                handlers = require("rzls.roslyn_handlers"),
                settings = {
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                        csharp_enable_inlay_hints_for_types = true,
                        dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        dotnet_enable_inlay_hints_for_literal_parameters = true,
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        dotnet_enable_inlay_hints_for_other_parameters = true,
                        dotnet_enable_inlay_hints_for_parameters = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                        dotnet_enable_tests_code_lens = true,
                    },
                    ["csharp|completion"] = {
                        dotnet_provide_regex_completions = true,
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_show_name_completion_suggestions = true,
                    },
                    ["csharp|highlighting"] = {
                        dotnet_highlight_related_json_components = true,
                        dotnet_highlight_related_regex_components = true,
                    },
                },
            })
            vim.lsp.enable("roslyn")
        end,
        init = function()
            vim.filetype.add({
                extension = {
                    razor = "razor",
                    cshtml = "razor",
                },
            })
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "Issafalcon/neotest-dotnet",
        },
        opts = {
            adapters = {
                ["neotest-dotnet"] = {
                    dap = {
                        justMyCode = false,
                        stopOnEntry = false,
                    },
                    custom_attributes = {
                        xunit = { "Fact", "Theory" },
                        nunit = { "Test", "TestCase" },
                        mstest = { "TestMethod" },
                    },
                },
            },
        },
    },
}
