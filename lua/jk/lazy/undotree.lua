return {
    "mbbill/undotree",

--TODO: jk - fix this later - I want to be able to automatically focus the undotree pane if applicable
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}
