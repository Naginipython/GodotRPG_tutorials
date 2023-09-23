extends Node2D

func _process(_delta):
	change_scene()

func change_scene():
	if global.transition_scene && global.current_scene == "cliffside":
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		global.finish_changing_scenes()

func _on_world_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_world_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
