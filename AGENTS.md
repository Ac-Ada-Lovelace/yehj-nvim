# Repository Guidelines

## Project Structure & Module Organization
`init.lua` bootstraps LazyVim and should stay lean so the rest of the configuration loads fast. Shared options and keymaps belong in `lua/config`, while plugin-specific tweaks live under `lua/plugins` using one file per concern (for example, `lua/plugins/treesitter.lua`). `lazy-lock.json` records exact plugin commits—commit it whenever the lockfile changes. Keep repo-local docs or assets in dedicated folders to avoid polluting the runtime path.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy! sync" +qa` installs/updates plugins without launching a UI and surfaces sync failures.
- `nvim --headless "+Lazy! check" +qa` verifies plugin health, git remotes, and pending updates.
- Run `nvim --clean --headless "+checkhealth" +qa` before pushing to confirm core providers (Python, Node, clipboard) are satisfied on a fresh session.
Use `:Lazy profile` inside Neovim if a change affects startup time.

## Coding Style & Naming Conventions
Lua code is formatted with `stylua` (`stylua lua` from the repo root). The enforced style is 2-space indentation, 120-column width, and spaces (see `stylua.toml`). Prefer descriptive module names (`lua/plugins/lsp.lua` over `misc.lua`) and keep top-level tables ordered: Lazy plugin specs, then `opts`, then keymaps or commands. Favor `local` functions over globals and document nonobvious behavior with terse comments.

## Testing & Validation
There is no automated test suite, so rely on reproducible headless runs. When adding keymaps or plugin settings, open a clean instance via `nvim --clean -u init.lua` to ensure the config boots without cached state. For LSP changes, call `:checkhealth lsp` and connect to at least one project buffer to confirm handlers fire. If you touch formatter or diagnostic settings, run `:lua vim.lsp.buf.format()` on a sample file to validate the toolchain.

## Commit & Pull Request Guidelines
Write imperative, present-tense commit subjects under ~60 characters (e.g., “tune cmp sources”) and describe motivation plus noteworthy side effects in the body. Group unrelated changes into separate commits to keep diffs reviewable. Pull requests should summarize the user-facing behavior, list manual verification commands executed, and link related issues or upstream PRs. Include screenshots or terminal captures when UX changes affect UI elements such as status lines or dashboard banners.
