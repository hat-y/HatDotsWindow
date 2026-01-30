# Conform and Obsidian Fix Plan

## Overview

This plan addresses configuration issues with LSP formatting tools and Obsidian keybindings in Neovim.

## Priority 1: LSP Installation Fix

### 1. Prettier Installation Fix

**Razon**: Prettier y Prettierd no están instalados en PATH

**Error log**: `prettierd.cmd` not found, `prettier.cmd` not found

**Solución recomendada**: Instalar con mason.nvim o manualmente

**Command**:
```vim
:MasonInstall prettier
```

**Manual Installation**:
```bash
npm install -g prettier
```

**Alternative**: Use Ruff instead of Prettier (see below)

---

### 2. Ruff Installation Fix

**Razon**: Ruff no está en PATH (0.45.5k ⭐ - Python formatter)

**Error**: "failed to install ruff"

**Solución**: Instalar con mason.nvim o pip

**Command**:
```vim
:MasonInstall ruff
```

**Manual Installation**:
```bash
pip install ruff
```

**Why Ruff**: Ruff replaces Prettier CLI for Python and TypeScript files

---

### 3. Markdownlint-cli2 Fix

**Error**: "markdownlint-cli2 unavailable"

**Solución**:
```vim
:MasonInstall markdownlint-cli2
```

---

## Priority 2: Obsidian Keybindings Fix

### Problem

Los mapeos de obsidian.nvim tienen un diseño "raro" para SPACE + o + s (Search)

**Archivos a revisar**:
- `C:\Users\hat\HatDotsWindow\nvim\lua\plugins\obsidian.lua`
- Buscar mappings en líneas 162-182

### Correct Keymap Example

Replace existing mappings with these intuitive patterns:

```lua
-- SPACE + o + o = New
{ "<leader>oo", "<cmd>ObsidianNew<cr>", desc = "New note" },

-- SPACE + o + s = Search
{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },

-- SPACE + o + n = Navigate next
{ "<leader>on", "<cmd>ObsidianNext<cr>", desc = "Next note" },

-- SPACE + o + p = Previous
{ "<leader>op", "<cmd>ObsidianPrev<cr>", desc = "Prev note" },

-- SPACE + o + l = Links
{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },

-- SPACE + o + b = Backlinks
{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" }
```

### Recommended Mappings

- `<leader>oo` - New note
- `<leader>on` - Navigate next
- `<leader>op` - Navigate previous
- `<leader>os` - Search
- `<leader>ok` - Quick switch
- `<leader>ol` - Buffer links
- `<leader>ob` - Backlinks
- `<leader>or` - Rename
- `<leader>ot` - Templates

### Testing Obsidian Keybindings

1. Open an Obsidian note in Neovim
2. Test each keybinding to ensure they work correctly
3. Verify that the new mappings are more intuitive

---

## Testing Steps

### 1. Restart Neovim

```bash
nvim
```

### 2. Install Tools with Mason

```vim
:MasonInstall prettier ruff markdownlint-cli2
```

### 3. Test Formatting

1. Create a `.ts` file
2. Run formatting command: `:Format`
3. Verify no errors appear

### 4. Test Obsidian Keybindings

1. Test SPACE + o + n (next note)
2. Test SPACE + o + p (previous note)
3. Test SPACE + o + s (search)
4. Test SPACE + o + o (new note)

### 5. Verify All Mappings Work

Check each mapping to ensure they trigger the correct Obsidian command

---

## Obsidian Navigation Commands

### Daily Notes

- `:ObsidianToday` - Open today's daily note
- `:ObsidianTomorrow` - Open tomorrow's daily note

### File Operations

- `:ObsidianNew` - Create new note
- `:ObsidianQuickSwitch` - Quick switch between notes
- `:ObsidianSearch` - Search in vault
- `:ObsidianTemplate` - Insert template

### Link Operations

- `:ObsidianLinks` - Show links to current note
- `:ObsidianBacklinks` - Show links from current note
- `:ObsidianFollowLink` - Follow a link (default: CTRL-i)

### Navigation

- `:ObsidianNext` - Jump to next link
- `:ObsidianPrev` - Jump to previous link
- `:ObsidianGoBack` - Go back to previous location
- `:ObsidianGoForward` - Go forward to next location

---

## Priority Order

### Priority 1: Install Prettier and Ruff (replaces Prettier CLI)
- Fixes formatting errors
- More reliable than CLI
- Better integration with LSP

### Priority 2: Install markdownlint-cli2
- Fixes linting issues
- Improves markdown quality

### Priority 3: Fix Obsidian keybindings (SPACE + o)
- Makes navigation more intuitive
- Improves user experience
- Reduces frustration

---

## Summary Checklist

- [ ] Install Prettier with Mason
- [ ] Install Ruff with Mason
- [ ] Install markdownlint-cli2 with Mason
- [ ] Review obsidian.lua mappings
- [ ] Replace SPACE + o mappings with intuitive patterns
- [ ] Test all keybindings
- [ ] Verify formatting works
- [ ] Test Obsidian navigation commands

---

## Expected Results

After completion:
1. No more formatting errors
2. Markdown linting works correctly
3. Obsidian keybindings are intuitive and consistent
4. Navigation between notes is smooth
5. All LSP tools are properly installed

---

## Troubleshooting

### If Prettier still fails
- Ensure npm is in PATH
- Check Neovim version (>= 0.8.0)
- Try manual npm install

### If Ruff fails
- Ensure Python and pip are installed
- Check Python version (>= 3.9)
- Verify pip is in PATH

### If Obsidian mappings don't work
- Verify obsidian.lua is loaded
- Check for syntax errors in Lua
- Ensure obsidian.nvim is properly configured
- Test with `:verbose map <leader>o` to see actual mappings

---

## Additional Resources

- Prettier docs: https://prettier.io/docs/en/install.html
- Ruff docs: https://docs.astral.sh/ruff/
- Obsidian.nvim docs: https://github.com/epwalsh/obsidian.nvim
- Mason docs: https://github.com/williamboman/mason.nvim