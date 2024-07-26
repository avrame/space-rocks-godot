extends Node2D

const MIN_SPEED = 25
const MAX_SPEED = 300
const MIN_DISTANCE_FROM_SHIP = 250

enum Size {SMALL, MEDIUM, LARGE}
@export var size = Size.LARGE

@onready var global = get_node("/root/Global")
@onready var asteroid_medium_scene = load("res://Scenes/asteroid-medium.tscn")
@onready var asteroid_small_scene = load("res://Scenes/asteroid-small.tscn")
@onready var spaceship = get_node("../SpaceShip")
@onready var LevelContainer = get_node("/root/Main/LevelContainer")
@onready var Score = get_node("/root/Main/Score")
@onready var screen_size = get_viewport_rect().size
var speed
var rotate_speed
var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if size == Size.LARGE:
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
	position = global.wrap_around(position)
	#$DebugLabel.text = str(round(spaceship.position.distance_to(position)))

func generate_random_position():
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	position = Vector2(x, y)
	
func explode():
	$Sprite2D.visible = false
	$AsteroidStaticBody.queue_free()
	$Explosion.emitting = true
	$ExplosionSound.play()
	match size:
		Size.LARGE:
			Score.increase_score(5)
			for i in 3:
				var medium_asteroid = asteroid_medium_scene.instantiate()
				medium_asteroid.transform = global_transform
				get_parent().add_child(medium_asteroid)
		Size.MEDIUM:
			Score.increase_score(10)
			for i in 3:
				var small_asteroid = asteroid_small_scene.instantiate()
				small_asteroid.transform = global_transform
				get_parent().add_child(small_asteroid)
		Size.SMALL:
			Score.increase_score(20)

func _on_explosion_finished() -> void:
	var asteroids = get_tree().get_nodes_in_group("Asteroids")
	if asteroids.size() == 0:
		LevelContainer.load_next_level()
	queue_free()
