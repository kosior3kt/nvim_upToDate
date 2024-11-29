return
{
	"kylechui/nvim-surround",
    config = function()
        require("nvim-surround").setup({
           keymaps={
               visual = "gs",
               normal = "gs",
           };
        })
    end
}
