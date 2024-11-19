vim.keymap.set("n", "<leader><leader>r", ":w !cargo run<CR>", {
    desc = "[R]un Rust App"
})

require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            }
        },
    },
})
