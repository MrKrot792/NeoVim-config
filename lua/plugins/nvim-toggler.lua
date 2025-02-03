return {
    'nguyenvukhang/nvim-toggler',
    config = function()
        require('nvim-toggler').setup({
          -- your own inverses
          inverses = {},
        })
    end
}
