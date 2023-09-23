extends Node2D

func _ready():
	if global.new_world:
		global.new_world = false
	else:
		$player.position.x = global.player_exit_cliffside_pos_x
		$player.position.y = global.player_exit_cliffside_pos_y + 10

func _process(_delta):
	change_scene()

func _on_cliffside_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false;

func change_scene():
	if global.transition_scene && global.current_scene == "world":
		get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
		global.player_exit_cliffside_pos_x = $player.position.x
		global.player_exit_cliffside_pos_y = $player.position.y
		global.finish_changing_scenes()

