extends Node2D

const MIN_SPEED = 25
const MAX_SPEED = 300
const MIN_DISTANCE_FROM_SHIP = 250

@onready var spaceship = get_node("../SpaceShip")
var screen_size
var speed
var rotate_speed
var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().content_scale_size
	generate_random_position()
	while position.distance_to(spaceship.position) < MIN_DISTANCE_FROM_SHIP:
		generate_random_position()
	speed = randf_range(MIN_SPEED, MAX_SPEED)
	rotate_speed = randfn(0, 1.5)
	var direction = randf_range(0, 2 * PI)
	velocity = Vector2.RIGHT.rotated(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(delta * rotate_speed)
	translate(delta * speed * velocity)
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0

func generate_random_position():
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	position = Vector2(x, y)
	
func explode():
	$Sprite2D.visible = false
	$Explosion.emitting = true
	$ExplosionSound.play()


func _on_explosion_finished() -> void:
	queue_free()
