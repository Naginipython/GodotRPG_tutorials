extends Marker2D

@onready var tilemap: TileMap = get_node("/root/GameManager/" + global.current_scene + "/TileMap")
@onready var botRight: Marker2D = get_node("/root/GameManager/" + global.current_scene + "/worldPos/botRight")

func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSize = mapRect.size * tileSize
	botRight.position.x = worldSize.x
	botRight.position.y = worldSize.y
	
