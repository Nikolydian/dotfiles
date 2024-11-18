vim.keymap.set("n", "<leader><leader>r", ":w go run<CR>", {
    desc = "[R]un Golang File"
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.code_action({
            context = {
                only = { "source.organizeImports" }
            },
            apply = true,
        })
    end
})
