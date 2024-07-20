extends CharacterBody2D


const ROTATION_SPEED = 5.0
const THRUST_SPEED = 10.0
const FRICTION = .99
const MAX_SPEED = 1000.0
const MIN_DISTANCE_FROM_ASTEROID = 400

var screen_size
var init_position
var init_rotation
var sprite_width
var sprite_height
var exploding = false

@onready var global = get_node("/root/Global")
@onready var lives_node = get_node("/root/Main/Lives")
@onready var game_over_node = get_node("/root/Main/GameOver")
@onready var sprite = $Sprite2D
@onready var left_engine_stream = $LeftEngineStream
@onready var right_engine_stream = $RightEngineStream


func _ready():
	init_position = position
	init_rotation = rotation
	screen_size = get_viewport().content_scale_size
	sprite_width = sprite.texture.get_width()
	sprite_height = sprite.texture.get_height()
	

func _physics_process(delta):
	if exploding:
		return
	if Input.is_action_pressed("rotate-left"):
		var rotate_amount = delta * -ROTATION_SPEED
		rotate(rotate_amount)
		right_engine_stream.emitting = true
	elif Input.is_action_pressed("rotate-right"):
		var rotate_amount = delta * ROTATION_SPEED
		rotate(rotate_amount)
		left_engine_stream.emitting = true
	
	if Input.is_action_pressed("thrust"):
		velocity = velocity + Vector2.UP.rotated(rotation) * THRUST_SPEED
		velocity = velocity.limit_length(MAX_SPEED)
		left_engine_stream.emitting = true
		right_engine_stream.emitting = true
	elif not Input.is_action_pressed("rotate-left") and not Input.is_action_pressed("rotate-right"):
		velocity = velocity * FRICTION
		left_engine_stream.emitting = false
		right_engine_stream.emitting = false
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
		
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider_name = collision.get_collider().get("name")
		if collider_name == "AsteroidStaticBody":
			explode()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		$PewPewSound.play()

func explode():
	exploding = true
	left_engine_stream.emitting = false
	right_engine_stream.emitting = false
	velocity = Vector2.ZERO
	$Sprite2D.visible = false
	$Explosion.emitting = true
	$ExplosionSound.playing = true

func _on_explosion_finished() -> void:
	lives_node.remove_a_life()
	$RespawnTimer.start()


func _on_respawn_timer_timeout() -> void:
	if game_over_node.visible:
		return
	if asteroids_too_close():
		$RespawnTimer.start()
		return
	position = init_position
	rotation = init_rotation
	$Sprite2D.visible = true
	exploding = false
	
		
func asteroids_too_close():
	var asteroids = get_tree().get_nodes_in_group("Asteroids")
	for asteroid in asteroids:
		if position.distance_to(asteroid.position) < MIN_DISTANCE_FROM_ASTEROID:
			return true
	return false
	