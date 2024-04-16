# fittencode.nvim

Fitten Code AI Programming Assistant for Neovim, helps you to use AI for automatic completion in Neovim, with support for functions like login, logout, shortcut key completion.

![fittencode-KMP-demo](https://github.com/luozhiya/fittencode.nvim/assets/90168447/d6fa4c66-f64b-4880-b7a9-4245226be0ac)

## ✨ Features

- 🚀 Fast completion thanks to `Fitten Code` and `curl`
- 🐛 Asynchronous I/O for improved performance
- ⭐️ Accept all suggestions with `Tab`
- 🧪 Accept line with `Ctrl + ⬇️`
- 🔎 Accept word with `Ctrl + ➡️`
- ❄️ Undo accepted text
- 🧨 Automatic scrolling when previewing or completing code
- 🛰️ Run as a `nvim-cmp` source

## ⚡️ Requirements

- Neovim >= 0.8.0
- curl

## 📦 Installation

Install the plugin with your preferred package manager:

#### For example with `lazy.nvim`:

```lua
{
  'pengchangg/fittencode.nvim',
  config = function()
    require('fittencode').setup()
  end,
}
```

#### For example with `packer.nvim`:

```lua
use {
  'pengchangg/fittencode.nvim',
  config = function()
    require('fittencode').setup()
  end,
}
```

## ⚙️ Configuration

### `defaults`

**fittencode.nvim** comes with the following defaults:

```lua
{
  disable_specific_inline_completion = {
    -- Disable auto-completion for some specific file suffixes by entering them below
    -- For example, `suffixes = {'lua', 'cpp'}`
    suffixes = {},
  },
  inline_completion = {
    -- Enable inline code completion.
    enable = true,
  },
  -- Set the mode of the completion.
  -- Available options:
  -- - 'inline' (default)
  -- - 'source'
  completion_mode = 'inline',
  use_default_keymaps = true,
  log = {
    level = vim.log.levels.WARN,
  },
}
```

### `inline` mode

Set `updatetime` to a lower value to improve performance:

```lua
-- Neovim default updatetime is 4000
vim.opt.updatetime = 200
```

### `source` mode

```lua
require('fittencode').setup({
  completion_mode ='source',
})
require('cmp').setup({
  sources = { name = 'fittencode', group_index = 1 },
  mapping = {
    ['<cr>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
  }
})
```

## 🚀 Usage

### Default Command

| Command         | Description                                                |
|-----------------|------------------------------------------------------------|
| `Fitten login`  | Try the command `Fitten login <user> <password>` to login. |
| `Fitten logout` | Logout account                                             |

### Default Mappings

| Mappings    | Action                 |
|-------------|------------------------|
| `F2`       | Accept all suggestions |
| `F3` | Accept line            |
| `F4` | Accept word            |

## 🎉 Special Thanks

- https://github.com/FittenTech/fittencode.vim
