extends Camera2D

@onready var scene = global.current_scene;
@onready var botRight = get_node("/root/GameManager/" + scene + "/worldPos/botRight")


func _ready():
	limit_top = 0
	limit_left = 0
	limit_bottom = botRight.position.y
	limit_right = botRight.position.x
