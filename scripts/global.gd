extends Node
#Project > Project Settings, Autoload. This allows every script to access this script

var player_current_attack = false

var current_scene = "world"; #world & cliffside
var transition_scene = false;

var player_exit_cliffside_pos_x = 0;
var player_exit_cliffside_pos_y = 0;

var new_world = true;

func finish_changing_scenes():
	if transition_scene:
		transition_scene = false
		match current_scene:
			"world":
				current_scene = "cliffside"
			"cliffside":
				current_scene = "world"
