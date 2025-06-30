return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    require('ufo').setup({
      -- Performance-focused settings
      open_fold_hl_timeout = 0,       -- No highlight delay
      close_fold_kinds = {},          -- Close all fold types
      preview = {
        win_config = {
          border = 'none'            -- No visual border
        }
      },

      provider_selector = function()
        return { 'treesitter', 'indent' }
      end
    })
  end
}
