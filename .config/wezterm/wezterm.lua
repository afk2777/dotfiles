local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["nord"]
require("on")

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

---------------------------------------------------------------
--- functions
---------------------------------------------------------------
local function enable_wayland()
  local wayland = os.getenv("XDG_SESSION_TYPE")
  if wayland == "wayland" then
    return true
  end
  return false
end

---------------------------------------------------------------
--- Merge the Config
---------------------------------------------------------------
local function insert_ssh_domain_from_ssh_config(c)
  if c.ssh_domains == nil then
    c.ssh_domains = {}
  end
  for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(c.ssh_domains, {
      name = host,
      remote_address = config.hostname .. ":" .. config.port,
      username = config.user,
      multiplexing = "None",
      assume_shell = "Posix",
    })
  end
  return c
end

--- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
  local m = package.searchpath(module, package.path)
  if m == nil then
    return {}
  end
  return dofile(m)
end

local local_config = load_local_config("local")
---------------------------------------------------------------
--- Config
---------------------------------------------------------------
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local config = {
  window_decorations = "RESIZE",
  check_for_updates = false,
  use_ime = true,
  -- ime_preedit_rendering = "System",
  -- use_dead_keys = true,
  warn_about_missing_glyphs = false,
  -- enable_kitty_graphics = false,
  animation_fps = 1,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  cursor_blink_rate = 0,
  -- enable_wayland = enable_wayland(),
  -- https://github.com/wez/wezterm/issues/1772
  enable_wayland = false,
  color_scheme = "iceberg-dark",
  color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
  hide_tab_bar_if_only_one_tab = false,
  adjust_window_size_when_changing_font_size = false,
  selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
  enable_kitty_graphics = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  use_fancy_tab_bar = false,
  colors = {
    tab_bar = {
      background = scheme.background,
      new_tab = { bg_color = "#2e3440", fg_color = scheme.ansi[8], intensity = "Bold" },
      new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
      -- format-tab-title
      -- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
      -- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
      -- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
    },
  },
  show_tab_index_in_tab_bar = true,
  tab_max_width = 500,
  tab_bar_at_bottom = false,
  -- window_background_opacity = 0.8,
  disable_default_key_bindings = true,
  enable_csi_u_key_encoding = true,
  leader = { key = "t", mods = "CTRL" },
  keys = keybinds.create_keybinds(),
  key_tables = keybinds.key_tables,
  mouse_bindings = keybinds.mouse_bindings,
}

local merged_config = utils.merge_tables(config, local_config)
return insert_ssh_domain_from_ssh_config(merged_config)
