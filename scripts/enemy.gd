extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 20
var player_in_attack_zone = false
var can_take_dmg = true

func _physics_process(_delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2.ZERO)
	else:
		$AnimatedSprite2D.play("idle")
	

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false

func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack and can_take_dmg:
		health -= 10
		$damage_cooldown.start()
		can_take_dmg = false
		print("slime took 10 damage")
		if health <= 0:
			self.queue_free()

func _on_damage_cooldown_timeout():
	can_take_dmg = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health;
	
	if health >= 20:
		healthbar.visible = false
	else:
		healthbar.visible = true