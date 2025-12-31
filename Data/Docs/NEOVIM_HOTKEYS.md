# Neovim Hotkeys Reference

## General Keybindings

### Basic Operations
- `Ctrl+s` - Save file
- `Ctrl+q` - Quit
- `Ctrl+a` - Force quit (without saving)
- `Esc` - Clear search highlighting

### Window Navigation
- `Ctrl+h` - Move to left window
- `Ctrl+j` - Move to window below
- `Ctrl+k` - Move to window above
- `Ctrl+l` - Move to right window

## Plugin Keybindings

### Telescope (Fuzzy Finder)
Leader key: `-`

- `-ff` - Find files
- `-fg` - Live grep (search text in files)
- `-fb` - Search buffers
- `-fh` - Search help tags

### NvimTree (File Explorer)
- `-e` - Toggle file explorer
- `Ctrl+n` - Toggle file explorer

### Comment.nvim
Uses default bindings (see `:help comment.nvim`)

## LSP (Language Server Protocol) - TypeScript

### Documentation & Information
- `K` - Show hover documentation for symbol under cursor
- `-d` - Open diagnostic float (show errors/warnings)

### Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Show all references
- `[d` - Go to previous diagnostic (error/warning)
- `]d` - Go to next diagnostic (error/warning)

### Code Actions & Refactoring
- `-rn` - Rename symbol
- `-ca` - Show code actions
- `-f` - Format current buffer

## Autocompletion (nvim-cmp)

### In Insert Mode
- `Ctrl+Space` - Trigger completion menu
- `Tab` - Select next item / expand snippet
- `Shift+Tab` - Select previous item / jump back in snippet
- `Enter` - Confirm selection
- `Ctrl+e` - Abort completion
- `Ctrl+b` - Scroll documentation up
- `Ctrl+f` - Scroll documentation down

## Configuration

### Auto-format on Save (Optional)
To enable automatic formatting when saving TypeScript files, edit `~/.config/nvim/init.lua` and uncomment lines 45-50:

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

## File Locations

- Main config: `~/.config/nvim/init.lua`
- Plugin manager: Lazy.nvim
- Colorscheme: Tokyo Night

## Tips

1. **Leader key is `-`** (dash/hyphen)
2. Press `K` on any TypeScript function/variable to see its documentation
3. Errors appear inline with red underlines and in the sign column
4. Use `[d` and `]d` to quickly navigate through all errors in a file
5. The completion menu appears automatically as you type
6. Press `Ctrl+Space` if completion doesn't trigger automatically
