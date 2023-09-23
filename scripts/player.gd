extends CharacterBody2D

const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 400

var input = Vector2.ZERO
var current_dir = "none"

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_process = false

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false #respawn screen, etc
		health = 0
		print("player has died")
		self.queue_free() #prob not good

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		# slowing down
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
			play_anim()
	else:
		# speeding up
		velocity += (input * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_SPEED)
		play_anim()
	
	move_and_slide()

# Movement Animations

func play_anim():
	var anim = $AnimatedSprite2D
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		anim.flip_h = false
		anim.play("side_walk")
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		anim.flip_h = true
		anim.play("side_walk")
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		anim.flip_h = false
		anim.play("front_walk")
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		anim.flip_h = false
		anim.play("back_walk")
	else:
		if !attack_process:
			match current_dir:
				"right": 
					anim.flip_h = false
					anim.play("side_idle")
				"left":
					anim.flip_h = true
					anim.play("side_idle")
				"down":
					anim.flip_h = false
					anim.play("front_idle")
				"up":
					anim.flip_h = false
					anim.play("back_idle")
				_:
					anim.play("front_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 10
		enemy_attack_cooldown = false
		$damage_cooldown.start()
		print("player - 10 damage")
	pass

func _on_damage_cooldown_timeout():
	enemy_attack_cooldown = true


func attack():
	var anim = $AnimatedSprite2D
	
	#"attack_[dir]" was created via Project > Project Settings > Input Map
	if Input.is_action_just_pressed("attack_right"):
		global.player_current_attack = true
		attack_process = true
		current_dir = "right"
		anim.flip_h = false
		anim.play("side_attack")
		$attack_cooldown.start()
	elif Input.is_action_just_pressed("attack_left"):
		global.player_current_attack = true
		attack_process = true
		current_dir = "left"
		anim.flip_h = true
		anim.play("side_attack")
		$attack_cooldown.start()
	elif Input.is_action_just_pressed("attack_down"):
		global.player_current_attack = true
		attack_process = true
		current_dir = "down"
		anim.flip_h = false
		anim.play("front_attack")
		$attack_cooldown.start()
	elif Input.is_action_just_pressed("attack_up"):
		global.player_current_attack = true
		attack_process = true
		current_dir = "up"
		anim.flip_h = false
		anim.play("back_attack")
		$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	$attack_cooldown.stop() #so it doesn't repeat?
	global.player_current_attack = false
	attack_process = false

func update_health():
	var healthbar = $healthbar
	healthbar.value = health;
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 5
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
