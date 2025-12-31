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
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Función de on_attach reutilizable para todos los LSPs
      local on_attach = function(client, bufnr)
        -- Keymaps para LSP
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Configuración del LSP de Aiken usando la nueva API vim.lsp.config
      vim.lsp.config.aiken = {
        cmd = { 'aiken', 'lsp' },
        filetypes = { 'aiken' },
        root_dir = vim.fs.root(0, { 'aiken.toml' }),
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Habilitar el servidor Aiken automáticamente
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'aiken',
        callback = function()
          vim.lsp.enable('aiken')
        end,
      })
    end,
  },

  -- TypeScript: Usaremos el servidor estándar para máxima compatibilidad con Nvim 0.11
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          -- Keymaps para LSP
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

          -- Formateo
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          -- Auto-formateo al guardar (opcional, descomenta si lo quieres)
          -- vim.api.nvim_create_autocmd("BufWritePre", {
          --   buffer = bufnr,
          --   callback = function()
          --     vim.lsp.buf.format({ async = false })
          --   end,
          -- })
        end,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
          },
        },
      })
    end,
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
        -- Agregar parsers personalizados
        parser_install_dir = vim.fn.stdpath("data") .. "/tree-sitter-parsers",
      })

      -- Añadir el directorio de parsers personalizados al runtimepath
      vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/tree-sitter-parsers")
    end,
  },

  -- Autocompletado
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

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
    "preservim/nerdtree",
    config = function()
      -- Configuración de NERDTree
      vim.g.NERDTreeWinSize = 30
      vim.g.NERDTreeShowHidden = 1  -- Mostrar archivos ocultos por defecto
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

-- --- CONFIGURACIÓN DE DIAGNÓSTICOS ---
vim.diagnostic.config({
  virtual_text = true,         -- Muestra errores inline
  signs = true,                -- Muestra iconos en la columna de signos
  update_in_insert = false,    -- No actualizar mientras escribes
  underline = true,            -- Subraya los errores
  severity_sort = true,        -- Ordena por severidad
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

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
keymap('n', '<C-w>', ':w<CR>', { silent = true })
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

-- NERDTree (Explorador de archivos)
keymap('n', '<leader>e', ':NERDTreeToggle<CR>', { desc = 'Toggle explorador de archivos' })
keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { desc = 'Toggle explorador de archivos' })
keymap('n', '<leader>nf', ':NERDTreeFind<CR>', { desc = 'Encontrar archivo actual en NERDTree' })

