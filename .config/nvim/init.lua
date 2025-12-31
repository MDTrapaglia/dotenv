-- --- 1. INSTALACIÓN DE LAZY.NVIM ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- 2. CONFIGURACIÓN DE PLUGINS ---
require("lazy").setup({
  -- LSP Config (Base para servidores de lenguaje)
  { 
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" }
  },

  -- TypeScript: Usaremos el servidor estándar para máxima compatibilidad con Nvim 0.10
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {}, -- Esto evita que el config falle si no está listo
  },

  -- Treesitter con protección
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Usamos pcall para que si falla, no bloquee todo Neovim
      local status, ts = pcall(require, "nvim-treesitter.configs")
      if not status then return end
      ts.setup({
        ensure_installed = { "typescript", "tsx", "javascript", "lua", "vim" },
        highlight = { enable = true },
      })
    end,
  },

  -- Autocompletado
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp" } },

  -- Comentar/Descomentar código
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Fuzzy Finder (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },

  -- Explorador de archivos en árbol
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
      })
    end,
  },

  -- Iconos para el tree y otros plugins
  { "nvim-tree/nvim-web-devicons" },

  -- Colores
  { "folke/tokyonight.nvim", config = function() vim.cmd.colorscheme("tokyonight") end },
})

-- --- AJUSTES DE INTERFAZ ---
vim.opt.number = true          -- Muestra números de línea
vim.opt.relativenumber = true  -- Números relativos (ayuda a saltar líneas rápido)
vim.opt.mouse = 'a'            -- Habilita el ratón
vim.opt.ignorecase = true      -- Ignorar mayúsculas al buscar
vim.opt.smartcase = true       -- No ignorar si la búsqueda tiene mayúsculas
vim.opt.termguicolors = true   -- Colores reales en la terminal
vim.opt.signcolumn = 'yes'     -- Siempre mostrar la columna de señales (evita saltos)
vim.opt.cursorline = true      -- Resalta la línea actual

-- --- AJUSTES DE IDENTACIÓN (Tabulaciones) ---
vim.opt.tabstop = 4            -- Ancho de un tabulador
vim.opt.shiftwidth = 4         -- Tamaño de la sangría
vim.opt.expandtab = true       -- Convertir tabs en espacios
vim.opt.smartindent = true     -- Indentación inteligente automática

-- --- COMPORTAMIENTO ---
vim.opt.clipboard = 'unnamedplus' -- Usa el portapapeles del sistema
vim.opt.updatetime = 250          -- Tiempo de respuesta más rápido (ms)
vim.opt.scrolloff = 8             -- Mantiene 8 líneas visibles arriba/abajo al bajar
vim.g.mapleader = '-'             -- Define la tecla "Espacio" como líder

-- --- ATAJOS DE TECLADO BÁSICOS ---
local keymap = vim.keymap.set
-- Limpiar resaltado de búsqueda con Esc
keymap('n', '<Esc>', ':nohlsearch<CR>', { silent = true })
-- Guardar con Ctrl + S (opcional, muy útil)
keymap('n', '<C-s>', ':w<CR>', { silent = true })
keymap('n', '<C-q>', ':q<CR>', { silent = true })
keymap('n', '<C-a>', ':q!')
-- Moverse entre ventanas fácilmente
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- --- ATAJOS PARA PLUGINS ---
-- Telescope (Fuzzy Finder)
keymap('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Buscar archivos' })
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Buscar texto en archivos' })
keymap('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Buscar en buffers abiertos' })
keymap('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Buscar en ayuda' })

-- nvim-tree (Explorador de archivos)
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle explorador de archivos' })
keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle explorador de archivos' })

