#!/usr/bin/env bash

# rofi_command="rofi -theme $dir/powermenu.rasi"
rofi_command="rofi -theme ~/.config/rofi/themes/gruvbox/gruvbox-dark.rasi"

# Options
xrandr1="xrandr ..."
xrandr2="xrandr ..."
xrandr3="xrandr ..."
xrandr4="xrandr ..."
xrandr5="xrandr --output DP-3 --mode 1920x1080 --rate 240.00 --output DP-1 --primary --mode 1920x1080 --rate 144.00 --right-of DP-3"

# Variable passed to rofi
options="$xrandr1\n$xrandr2\n$xrandr3\n$xrandr4\n$xrandr5"

chosen="$(echo -e "$options" | $rofi_command -p "Choose a command" -dmenu -selected-row 0)"
case $chosen in
    $xrandr1)
		$xrandr1
        ;;
    $xrandr2)
		$xrandr2
        ;;
    $xrandr3)
		$xrandr3
        ;;
    $xrandr4)
		$xrandr4
        ;;
    $xrandr5)
		# urxvt -e bash -c 'nvim ~/.local/bin/my_scripts/script_help_docs/other.txt; zsh'
		$xrandr5
        ;;
esac
