vim.keymap.set("n", "<leader><leader>rr", ":w !cargo run<CR>", {
    desc = "[R]un Rust App"
})

vim.keymap.set("n", "<leader><leader>rt", ":w !cargo test<CR>", {
    desc = "[R]un Rust [T]ests"
})

vim.keymap.set("n", "<leader><leader>rb", ":w !cargo build<CR>", {
    desc = "[R]un Rust [B]uild"
})

vim.keymap.set("n", "<leader><leader>rc", ":w !cargo check<CR>", {
    desc = "[R]un Rust [C]heck"
})

vim.keymap.set("n", "<leader><leader>rx", ":w !cargo clean<CR>", {
    desc = "[R]un Rust Clean"
})

vim.keymap.set("n", "<leader><leader>rp", ":w !cargo bench<CR>", {
    desc = "[R]un Rust Benchmarks"
})

vim.keymap.set("n", "<leader><leader>rd", ":w !cargo doc<CR>", {
    desc = "[R]un Rust [D]ocs"
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
