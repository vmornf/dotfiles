-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jonas/.config/awesome/theme-def.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    --awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])
    local names = { "1", "2", "3", "4", "5"}
    local l = awful.layout.suit
    local layouts = { l.tile, l.tile, l.tile, l.tile, l.floating }
    awful.tag(names, s, layouts)

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")end),

    awful.key({}, "F6", function() awful.util.spawn("playerctl play-pause", false) end),

    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")end),

    awful.key({}, "XF86MonBrightnessDown", function() awful.util.spawn("xbacklight -dec 10") end),

    awful.key({}, "XF86MonBrightnessUp", function() awful.util.spawn("xbacklight -inc 10") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn("/home/jonas/.local/bin/my_scripts/term_wd.sh urxvt") end,
              {description = "open a terminal in wd", group = "launcher"}),
    awful.key({ modkey,"Shift"       }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "+",     function () awful.tag.incgap(0.5)     end,
              {description = "increase gaps ", group = "layout"}),
    awful.key({ modkey,           }, "-",     function () awful.tag.incgap(-0.5)     end,
              {description = "decrease gaps ", group = "layout"}),
    awful.key({ modkey,           }, "o",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "y",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "y",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "o",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "y",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "o",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "d",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "a",     function ()
    awful.util.spawn(terminal.. " -e bash -c tmux attach || tmux")                                            end,
              {description = "run tmux", group = "launcher"}),

    awful.key({ modkey },            "g",     function ()
    awful.spawn(terminal.. " -e bash -c nvim -c 'FZF ~'")                                            end,
              {description = "run tmux", group = "launcher"}),

    awful.key({ modkey },            "d",     function ()
    awful.util.spawn("rofi -show run -theme ~/.config/rofi/themes/gruvbox/gruvbox-dark.rasi")                                            end,
              {description = "run rofi", group = "launcher"}),

    awful.key({ modkey },            "r",     function ()
    awful.util.spawn("dmenu_run -fn 'Linux Libertine Mono'")                                            end,
              {description = "run rofi", group = "launcher"}),

    awful.key({ modkey },            "w",     function ()
    awful.util.spawn(terminal.. " -e sh ranger")                                            end,
              {description = "run ranger", group = "launcher"}),

    awful.key({ modkey },            "e",        function ()
    awful.util.spawn("/home/jonas/.local/bin/my_scripts/ranger_wd.sh urxvt" )                                                       end,
              {description = "run ranger in wd", group = "launcher"}),

    awful.key({ modkey, "Shift"     },            "e",        function ()
    awful.spawn.with_shell("~/.config/polybar/forest/scripts/powermenu.sh")                                                       end,
              {description = "Run powermenu", group = "launcher"}),

    awful.key({ modkey, "Shift"     },            "w",        function ()
    awful.spawn("firefox")                                                       end,
              {description = "Run firefox", group = "launcher"}),

    awful.key({ modkey },            "`",        function ()
    awful.spawn.with_shell("sh ~/.local/bin/powermenu")                                                       end,
              {description = "power options", group = "awesome"}),

    awful.key({ modkey },            "n",     function ()
    awful.util.spawn("sh /home/jonas/.local/bin/my_scripts/nautilus_wd.sh")                                            end,
              {description = "run nautilus in wd", group = "launcher"}),

    awful.key({ modkey, "Shift"    },            "n",     function ()
    awful.util.spawn("nautilus -w --no-desktop")                                            end,
              {description = "run nautilus", group = "launcher"}),

    awful.key({},            "F4",        function ()
    awful.spawn.with_shell("flameshot gui")                                                       end,
              {description = "run flameshot", group = "launcher"}),

    awful.key({ modkey, "Shift"     },            "s",        function ()
    awful.spawn.with_shell("import png:- | xclip -selection clipboard -t image/png")                                                       end,
              {description = "Screenshot to cb", group = "launcher"}),

    awful.key({ modkey, "Control"     },            "s",        function ()
    awful.spawn.with_shell("/home/jonas/.local/bin/my_scripts/tesseract_ocr.sh")                                                       end,
              {description = "Screenshot ocr", group = "launcher"}),

-- bindsym Print --release exec ~/.local/bin/my_scripts/screenshot_select.sh
-- bindsym shift+Print exec ~/.local/bin/my_scripts/screenshot.sh
-- bindsym $mod+Print --release exec ~/.local/bin/my_scripts/screenshot_ocr.sh
-- bindsym $mod+section exec --no-startup-id ~/.local/bin/my_scripts/loadEww.sh
-- # Lock screen 
-- bindsym $mod+Shift+x exec i3lock-fancy
-- bindsym $mod+Control+x exec i3lock -i ~/Downloads/lock-wallpaper.png 
-- #Suspend 
-- bindsym $mod+Shift+comma exec ~/.local/bin/my_scripts/alert_exit.sh; exec ~/.local/bin/my_scripts/suspend.sh
-- bindsym $mod+Shift+period exec i3lock-fancy; exec ~/.local/bin/my_scripts/alert_exit.sh; exec systemctl suspend
-- bindsym $mod+v exec ~/.local/bin/my_scripts/clip_history.sh
-- bindsym $mod+Shift+v exec ~/.local/bin/my_scripts/qr_clip.sh
-- bindsym $mod+period exec ~/.local/bin/my_scripts/emojipick/emojipick
-- # Program shortcuts
-- bindsym $mod+b exec urxvt -e sudo htop
-- bindsym $mod+Shift+b exec urxvt -e sudo bashtop
-- bindsym $mod+Control+b exec urxvt -e sudo ytop
-- bindsym $mod+m exec spotify
-- bindsym $mod+Shift+m exec flatpak run org.jamovi.jamovi
-- bindsym $mod+Control+m exec ~/.local/bin/my_scripts/tstock.sh

    awful.key({ modkey, "Shift"    },            "p",     function ()
    awful.util.spawn("/home/jonas/.local/bin/my_scripts/toggle_polybar.sh")                                            end,
              {description = "run nautilus", group = "launcher"}),

    awful.key({ modkey },            "p",        function ()
    awful.spawn.with_shell("scrcpy -S --power-off-on-close --window-x 10")                                                       end,
              {description = "run scrcpy", group = "launcher"}))

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({modkey}, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({modkey}, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, "Shift"      }, "d",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { instance = "Firefox" },
    properties = { tag = "1" } },

    { rule = { instance = "discord" },
    properties = { tag = "2" } },

    { rule = { instance = "feh"},
    properties = { floating = true } },

    { rule = { instance = "scrcpy"},
    properties = { floating = true } },

    { rule = { instance = "polybar"},
    properties = { border_width = 0 } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
        awful.placement.centered(c)
    end
end)

-- Notifications

beautiful.notification_font = "Product Sans 10"
beautiful.notification_width = 325
beautiful.notification_height = 125
beautiful.notification_icon_size = 115
beautiful.notification_border_color = "#1e1e2e"
beautiful.notification_fg = "#f5e0dc"
naughty.config.defaults.timeout = 4
naughty.config.padding = 11
naughty.config.spacing = 5

-- Autostart

-- awful.spawn.with_shell("picom --experimental-backends")
awful.spawn.with_shell("picom")
-- awful.spawn.with_shell('xinput disable "ETPS/2 Elantech Touchpad"')
-- awful.spawn.with_shell('xinput set-prop "MOSART Semi. MI Mouse A1w Mouse" "Coordinate Transformation Matrix" 2.4 0 0 0 2.4 0 0 0 1')
-- awful.spawn.with_shell("redshift -l 26.449923:80.331871")
-- awful.spawn.with_shell("polybar left")
-- awful.spawn.with_shell("polybar right")
-- awful.spawn.with_shell("polybar middle")
awful.spawn.with_shell("~/.config/polybar/launch.sh --forest")
-- awful.spawn.with_shell("unclutter")
-- awful.spawn.with_shell("firefox")
-- awful.spawn.with_shell("discord")
-- awful.spawn.with_shell("xautolock -time 30 -locker 'systemctl suspend'")
