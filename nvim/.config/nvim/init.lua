-- NEOVIM CONFIG

-- Set Leader Key
-- NOTE: Leader Key Config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load Lazy Plugins
-- NOTE: Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
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

-- Install Plugins
-- NOTE: Plugins Install Section
require("lazy").setup({
    spec = {
        -- NOTE: Install Themes
        {
            "nyoom-engineering/oxocarbon.nvim",
            lazy = false,
            priority = 1000,
        },
        { "rebelot/kanagawa.nvim", lazy = true },

        -- Which-Key
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },

        -- Lualine
        {
            "nvim-lualine/lualine.nvim",
            dependencies = {
                {
                    "nvim-tree/nvim-web-devicons",
                    enabled = vim.g.have_nerd_font,
                },
                {
                    "echasnovski/mini.nvim",
                    version = false,
                    -- config = function() end,
                },
            },
        },

        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-file-browser.nvim",
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                    cond = function()
                        return vim.fn.executable "make" == 1
                    end,
                },
                "nvim-telescope/telescope-ui-select.nvim",
            },
        },

        -- Todo Comments
        {
            "folke/todo-comments.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            opts = {},
            config = function()
                require("todo-comments").setup({})
            end,
        },

        -- Fidget (Notifications)
        {"j-hui/fidget.nvim"},

        -- Surround
        {
            "kylechui/nvim-surround",
            -- tag = "*",
        },

        -- Bufferline
        {
            "akinsho/bufferline.nvim",
            -- tag = "*",
            requires = "nvim-tree/nvim-web-devicons",
            config = function()
                require("bufferline").setup({})
            end,
        },

        -- LSP
        -- NOTE: LSP Install Plugins

        -- CMP
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                {
                    "L3MON4D3/LuaSnip",
                    build = (function()
                        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
                            return
                        end
                        return "make install_jsregexp"
                    end)(),
                    dependencies = {
                        -- {
                        --     "rafamadriz/friendly-snippets",
                        --     config = function()
                        --         require("luasnip.loaders.from_vscode").lazy_load()
                        --     end,
                        -- },
                    },
                },
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
            },
        },

        -- NVIM LSPConfig
        {
            "neovim/nvim-lspconfig",
            cmd = {"LspInfo", "LspInstall", "LspStart"},
            event = {"BufReadPre", "BufNewFile"},
            dependencies = {
                {"hrsh7th/cmp-nvim-lsp"},
                {"williamboman/mason.nvim"},
                {"williamboman/mason-lspconfig.nvim"},
                {"folke/neodev.nvim", opts = {}},
            },
        },

    },
    install = { colorscheme = { "oxocarbon" } },
    checker = {
        enabled = true,
        notify = true,
    },
})

-- Set Basic Options
-- NOTE: Basic Options Config

-- Mouse
vim.opt.mouse = "a"

-- Terminal
vim.opt.termguicolors = true

-- Numbers Column
vim.opt.number = true
vim.opt.relativenumber = true

-- Sync clipboard between OS and Neovim
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displayes which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display certain whitespace characters
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview subsitutions live, as you type
vim.opt.cursorline = true

-- Scrolloff
vim.opt.scrolloff = 8

-- Tab Settings
-- NOTE: Tab Tabstop Shiftwids Expandtab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.expandtab = true

-- Visible Column Breakline
vim.opt.colorcolumn = "81"

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Colorscheme
-- NOTE: Theme Colorscheme Background Config
vim.opt.background = "dark"
vim.cmd("colorscheme oxocarbon")

-- Autocommands
-- see `:help lua-guide-autocommands
-- NOTE: Autocommands Config
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Toggle Function
local function vim_opt_toggle(opt, on, off, name)
    if vim.opt[opt]:get() == off then
        vim.opt[opt] = on
    else
        vim.opt[opt] = off
    end
    local msg = name .. " toggled ..."
    vim.notify(msg)
end

-- Basic Keymaps
-- NOTE: Keymaps Basic Config

-- Keymap Helper Function
local mapkey = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, {
        desc = desc,
    })
end

-- Clear Highlight on Search
mapkey("<Esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlights")

-- Source File
mapkey("<leader><leader>s", ":so %<CR>", "[S]ource File")

-- Diagnostic Keymaps
mapkey("<leader>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix List")
mapkey("[d", vim.diagnostic.goto_prev, "Diagnostic Go to Previous")
mapkey("]d", vim.diagnostic.goto_next, "Diagnostic Go to Next")
mapkey("<leader>e", vim.diagnostic.open_float, "Diagnostic Open Float")

-- Move Line UP and DOWN
mapkey("J", ":m \'>+1<CR>gv=gv", "Move Line Up", "v")
mapkey("K", ":m \'<-2<CR>gv=gv", "Move Line Up", "v")

-- Yank to System Clipboard
mapkey("<leader>y", "\"+y")
mapkey("<leader>Y", "\"+Y")
mapkey("<leader>Y", "\"+Y", "", "v")

-- Split Windows Movement
mapkey("<C-h>", "<C-w><C-h>", "Move Focus to the Left Window")
mapkey("<C-l>", "<C-w><C-l>", "Move Focus to the Right Window")
mapkey("<C-j>", "<C-w><C-j>", "Move Focus to the Lower Window")
mapkey("<C-k>", "<C-w><C-k>", "Move Focus to the Upper Window")

-- Exit Terminal Mode
mapkey("<Esc><Esc>", "<C-\\><C-n>", "Exit Terminal Mode", "t")

-- Buffer Keymaps
mapkey("<leader>bf", ":bfirst<CR>", "[B]uffer [F]irst")
mapkey("<leader>bl", ":blast<CR>", "[B]uffer [L]ast")
mapkey("<leader>bp", ":bprev<CR>", "[B]uffer [P]revious")
mapkey("<leader>bn", ":bnext<CR>", "[B]uffer [N]next")
mapkey("<leader>bd", ":bdelete<CR>", "[B]uffer [D]elete")

-- Format Default
mapkey("<leader><leader>ff", vim.lsp.buf.format, "[F]ormat [F]ile Default")

-- Makefile
mapkey("<leader><leader>mm", ":w !make<CR>", "make all")
mapkey("<leader><leader>mb", ":w !make build<CR>", "make build")
mapkey("<leader><leader>mr", ":w !make run<CR>", "make run")
mapkey("<leader><leader>mt", ":w !make test<CR>", "make test")

-- Toggle
mapkey(
    "<leader><leader>tb",
    function()
        vim_opt_toggle("background", "light", "dark", "background")
    end,
    "[T]oggle [B]ackground"
)
mapkey(
    "<leader><leader>tr",
    function()
        vim_opt_toggle("relativenumber", true, false, "relativenumber")
    end,
    "[T]oggle [R]elative Numbers"
)

-- Config Plugins
-- NOTE: Plugins Configs

-- Lualine
require("lualine").setup({})
vim.opt.showmode = false

-- Whichkey
local whichkey = require("which-key")
whichkey.setup({})
whichkey.add({
    { "<leader><leader>t", group = "[T]oggle", mode = {"n"} },
    { "<leader><leader>m", group = "[M]ake", mode = {"n"} },
    { "<leader><leader>r", group = "[R]un", mode = {"n"} },
    { "<leader><leader>f", group = "[F]ormat File", mode = {"n"} },
    { "<leader>f", group = "[F]ind (Telescope)", mode = {"n"} },
    { "<leader>b", group = "[B]uffer", mode = {"n"} },
    -- { "<leader>w", group = "[W]orkspace", mode = {"n"} },
})

-- Telescope
-- NOTE: Telescope Config
require("telescope").setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})

pcall(require("telescope").load_extension, "file_browser")
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

mapkey("<leader>ff", builtin.find_files, "[F]ind [F]iles | Telescope")
mapkey("<leader>fl", builtin.oldfiles, "[F]ind O[L]d Files | Telescope")
mapkey("<leader>fg", builtin.live_grep, "[F]ind [G]rep | Telescope")
mapkey("<leader>fh", builtin.help_tags, "[F]ind [H]elp | Telescope")
mapkey("<leader>fd", builtin.diagnostics, "[F]ind [D]iagnostics | Telescope")
mapkey("<leader>fo", builtin.buffers, "[F]ind [O]pen Buffers | Telescope")
mapkey("<leader>fs", builtin.lsp_document_symbols, "[F]ind [S]ymbols | Telescope")
mapkey("<leader>fw", builtin.grep_string, "[F]ind Current [W]ord | Telescope")
mapkey("<leader>fk", ":Telescope keymaps<CR>", "[F]ind [K]eymaps | Telescope")
mapkey("<leader>fb", ":Telescope file_browser<CR>", "[F]ind File [B]rowser | Telescope")
mapkey("<leader>ft", ":TodoTelescope<CR>", "[F]ind [T]ODOs | Telescope")

mapkey("<leader>f/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        windblend = 10,
        previewer = false,
    })
end, "[/] Fuzzily search in current buffer")

-- LSP Config
-- NOTE: LST Config
local lsp_defaults = require("lspconfig").util.default_config

-- Add cmp_nvim_lsp capabilities settings to lspconfig
lsp_defaults.capabilities = vim.tbl_deep_extend(
    "force",
    lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    desc = "LSP actions",
    callback = function(event)

        -- Keymap Helper Function
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, {
                buffer = event.buf,
                desc = "LSP: " .. desc
            })
        end

        local builtin = require("telescope.builtin")

        map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("gr", builtin.lsp_references, "[G]oto [R]eferences")
        map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinitions")
        map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", {"n", "x"})
        map("K", vim.lsp.buf.hover, "Show a tooltip")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    end,
})

require("neodev").setup({})
require("fidget").setup({})

-- Mason Settings
-- NOTE: Mason Config
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {},
    handlers = {
        -- Default config
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,
    }
})

-- CMP Settings
-- NOTE: CMP Config
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
    completion = {
        completeopt = "menu,menuone,noinsert"
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    }),
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
})

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./mysnippets" } })

-- Surround
require("nvim-surround").setup({})

