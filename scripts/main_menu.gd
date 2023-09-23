extends Control

signal start_game()
@onready var btn_vbox = %BtnVBox

func _ready():
	focus_button()

func _on_start_game_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	hide()

func _on_quit_game_btn_pressed():
	get_tree().quit()

func _on_visibility_changed():
	if visible:
		focus_button()

func focus_button():
	if btn_vbox:
		var button: Button = btn_vbox.get_child(0)
		if button is Button:
			button.grab_focus()
