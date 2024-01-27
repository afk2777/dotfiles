local wezterm = require("wezterm")
local utils = require("utils")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["nord"]
local act = wezterm.action
---------------------------------------------------------------
--- wezterm on
---------------------------------------------------------------
local function update_window_background(window, pane)
  local overrides = window:get_config_overrides() or {}

  if overrides.color_scheme == nil then
    return
  end
  if pane:get_user_vars().production == "1" then
    overrides.color_scheme = "OneHalfDark"
  end
  window:set_config_overrides(overrides)
end

local function update_tmux_style_tab(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local hostname, cwd = utils.split_from_url(cwd_uri)
  return {
    { Attribute = { Underline = "Single" } },
    { Attribute = { Italic = true } },
    { Text = hostname },
  }
end

local function update_ssh_status(window, pane)
  local text = pane:get_domain_name()
  if text == "local" then
    text = ""
  end
  return {
    { Attribute = { Italic = true } },
    { Text = text .. " " },
  }
end

local function display_ime_on_right_status(window, pane)
  local compose = window:composition_status()
  if compose then
    compose = "COMPOSING: " .. compose
  end
  window:set_right_status(compose)
end

local function display_copy_mode(window, pane)
  local name = window:active_key_table()
  if name then
    name = "Mode: " .. name
  end
  return { { Attribute = { Italic = false } }, { Text = name or "" } }
end

wezterm.on("update-right-status", function(window, pane)
  -- local tmux = update_tmux_style_tab(window, pane)
  local ssh = update_ssh_status(window, pane)
  local copy_mode = display_copy_mode(window, pane)
  update_window_background(window, pane)
  local status = utils.merge_lists(ssh, copy_mode)
  window:set_right_status(wezterm.format(status))
end)

wezterm.on("toggle-tmux-keybinds", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.95
    overrides.keys = keybinds.default_keybinds
  else
    overrides.window_background_opacity = nil
    overrides.keys = utils.merge_lists(keybinds.default_keybinds, keybinds.tmux_keybinds)
  end
  window:set_config_overrides(overrides)
end)

local io = require("io")
local os = require("os")

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  local scrollback = pane:get_lines_as_text()
  local name = os.tmpname()
  local f = io.open(name, "w+")
  f:write(scrollback)
  f:flush()
  f:close()
  window:perform_action(
    act({
      SpawnCommandInNewTab = {
        args = { os.getenv("HOME") .. "/.local/share/zsh/zinit/polaris/bin/nvim", name },
      },
    }),
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)
