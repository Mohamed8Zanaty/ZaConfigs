
## Modes

| Key | Action |
|-----|--------|
| `i` | Insert mode (before cursor) |
| `a` | Insert mode (after cursor) |
| `I` | Insert at beginning of line |
| `A` | Insert at end of line |
| `o` | New line below and insert |
| `O` | New line above and insert |
| `v` | Visual mode |
| `V` | Visual line mode |
| `Ctrl + v` | Visual block mode |
| `Esc` | Back to normal mode |

---

## Navigation

### Basic Movement
| Key | Action |
|-----|--------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |

### Word Movement
| Key | Action |
|-----|--------|
| `w` | Next word start |
| `b` | Previous word start |
| `e` | Next word end |
| `W` | Next WORD start (ignores punctuation) |
| `B` | Previous WORD start (ignores punctuation) |

### Line Movement
| Key | Action |
|-----|--------|
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | First line of file |
| `G` | Last line of file |
| `{n}G` | Go to line n |
| `%` | Jump to matching bracket |

### Screen Movement
| Key | Action |
|-----|--------|
| `Ctrl + d` | Scroll half page down |
| `Ctrl + u` | Scroll half page up |
| `Ctrl + f` | Scroll full page down |
| `Ctrl + b` | Scroll full page up |
| `zz` | Center cursor on screen |

---

## Editing

### Copy / Paste
| Key | Action |
|-----|--------|
| `yy` | Copy (yank) current line |
| `y$` | Yank to end of line |
| `yiw` | Yank inner word |
| `3yy` | Yank 3 lines |
| `"+yy` | Yank to system clipboard |
| `"+y` | Yank selection to system clipboard |
| `p` | Paste after cursor |
| `P` | Paste before cursor |

### Delete
| Key | Action |
|-----|--------|
| `dd` | Delete (cut) current line |
| `"_dd` | Delete line without cutting |
| `D` | Delete to end of line |
| `dw` | Delete word |
| `diw` | Delete inner word |
| `d$` | Delete to end of line |
| `3dd` | Delete 3 lines |
| `dj` | Delete current + next line |
| `dk` | Delete current + previous line |
| `x` | Delete character under cursor |

### Change
| Key | Action |
|-----|--------|
| `cc` | Change entire line |
| `cw` | Change word |
| `ciw` | Change inner word |
| `c$` | Change to end of line |
| `C` | Change to end of line |
| `r` | Replace single character |
| `R` | Replace mode |

### Undo / Redo
| Key | Action |
|-----|--------|
| `u` | Undo |
| `Ctrl + r` | Redo |
| `.` | Repeat last action |

---

## Search & Replace

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:s/old/new/g` | Replace all in current line |

---

## Visual Mode

| Key | Action |
|-----|--------|
| `v` | Character selection |
| `V` | Line selection |
| `Ctrl + v` | Block selection |
| `gc` | Comment selected lines (requires plugin) |
| `"+y` | Copy selection to system clipboard |
| `d` | Delete selection |
| `y` | Yank selection |
| `>` | Indent selection |
| `<` | Unindent selection |

---

## Comments

> Requires `Comment.nvim` or similar plugin

| Key | Action |
|-----|--------|
| `gcc` | Comment/uncomment current line |
| `gc3j` | Comment 3 lines down |
| `gc` | Comment selected lines (visual mode) |

---

## Indentation

| Key | Action |
|-----|--------|
| `>>` | Indent line |
| `<<` | Unindent line |
| `==` | Auto-indent line |
| `gg=G` | Auto-indent entire file |
| `>3j` | Indent 3 lines down |

---

## Splits & Tabs

| Key | Action |
|-----|--------|
| `:sp` | Horizontal split |
| `:vsp` | Vertical split |
| `Ctrl + w + h/j/k/l` | Navigate between splits |
| `Ctrl + w + q` | Close split |
| `Ctrl + w + =` | Equal size splits |
| `:tabnew` | New tab |
| `gt` | Next tab |
| `gT` | Previous tab |

---

## File

| Key | Action |
|-----|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:wqa` | Save and quit all |
| `:e filename` | Open file |
| `:r filename` | Insert file content below cursor |

---

## Clipboard (System)

| Key | Action |
|-----|--------|
| `"+yy` | Copy line to system clipboard |
| `"+y` | Copy selection to system clipboard |
| `"+p` | Paste from system clipboard |

> Add `vim.opt.clipboard = "unnamedplus"` to `init.lua` to sync clipboard automatically.

---

## Useful Tricks

| Key | Action |
|-----|--------|
| `Ctrl + o` | Jump to previous location |
| `Ctrl + i` | Jump to next location |
| `gd` | Go to definition |
| `K` | Show hover docs (LSP) |
| `~` | Toggle case of character |
| `gU` | Uppercase selection |
| `gu` | Lowercase selection |
| `Ctrl + a` | Increment number under cursor |
| `Ctrl + x` | Decrement number under cursor |
| `:checkhealth` | Check nvim health |
