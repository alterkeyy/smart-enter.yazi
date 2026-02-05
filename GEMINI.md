# GEMINI context for smart-enter.yazi

## Project Overview
`smart-enter.yazi` is a plugin for the [Yazi](https://github.com/sxyazi/yazi) terminal file manager. It simplifies navigation by mapping a single key (typically `l`) to either enter a directory or open a file, depending on what is currently hovered.

- **Primary Language:** Lua
- **Platform:** Yazi Terminal File Manager

## Plugin Logic
The plugin's logic is contained in `main.lua`:
- It checks if the currently hovered item is a directory (`h.cha.is_dir`).
- If it's a directory, it recursively finds the **innermost** folder if there is exactly one subfolder and no other files at each level. It then uses the `cd` command to navigate directly to that innermost directory.
- If it's a file (or the directory has multiple entries/no subfolders), it emits the `open` command (for files) or `cd` (for simple directories).
- It supports an `open_multi` option (configured via `setup`) to determine if `open` should target all selected files or just the hovered one.

## Configuration
Users can configure the plugin in their `~/.config/yazi/init.lua`:
```lua
require("smart-enter"):setup {
    open_multi = true, -- If true, open targets multiple selected files; if false (default), only the hovered file.
}
```

## Installation & Usage
### Installation
Using the Yazi package manager:
```sh
ya pkg add yazi-rs/plugins:smart-enter
```

### Keybinding
Add the following to `~/.config/yazi/keymap.toml`:
```toml
[[mgr.prepend_keymap]]
on   = "l"
run  = "plugin smart-enter"
desc = "Enter the child directory, or open the file"
```

## Development Conventions
- **Main Entry Point:** `main.lua`
- **API Version:** Targets Yazi version `25.5.31` or later (as per `@since` tag).
- **Execution Mode:** Synchronous (`@sync entry`).
- **Communication:** Uses `ya.emit` to trigger internal Yazi commands (`cd` or `open`).

### Testing
No automated tests are present in the repository. Verification is performed manually within the Yazi environment.
