# nvim-log-helper

This is a neovim plugin. It does one thing:

Given the cursor is positioned within a JavaScript class method, invoking the plugin will insert `console.log("<method-name>");` on the current line.

## Usage

Requires `nvim-treesitter`.

Configure the plugin with lua like so:

```lua
vim.keymap.set('n', '<leader>fl', ':lua require"nvim-log-helper".run()<cr>')
```

## License

MIT
