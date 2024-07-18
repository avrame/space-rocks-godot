extends CharacterBody2D


const ROTATION_SPEED = 5.0
const THRUST_SPEED = 10.0
const FRICTION = .99
const MAX_SPEED = 1000.0

var screen_size
var sprite_width
var sprite_height
@onready var sprite = $Sprite2D

func _ready():
	screen_size = get_viewport().content_scale_size
	sprite_width = sprite.texture.get_width()
	sprite_height = sprite.texture.get_height()
	

func _physics_process(delta):
	if Input.is_action_pressed("rotate-left"):
		rotate(delta * -ROTATION_SPEED)
	elif Input.is_action_pressed("rotate-right"):
		rotate(delta * ROTATION_SPEED)
	
	if Input.is_action_pressed("thrust"):
		velocity = velocity + Vector2.UP.rotated(rotation) * THRUST_SPEED
		velocity = velocity.limit_length(MAX_SPEED)
	else:
		velocity = velocity * FRICTION
		
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
		
	move_and_collide(velocity * delta)
