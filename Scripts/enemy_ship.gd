extends Node2D

@onready var screen_size = get_viewport_rect().size
@onready var Level = get_node("/root/Main/LevelContainer/Level")
const SPEED = 150
var sprite_width
var sprite_height
var velocity = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_width = $Sprite2D.texture.get_width()
	sprite_height = $Sprite2D.texture.get_height()
	$EngineNoise.play()
	var y_pos = randi_range(screen_size.y / 4, 3 * screen_size.y / 4)
	position = Vector2(-sprite_width, y_pos)
	change_direction()
	start_change_dir_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += delta * velocity * SPEED
	if position.x > screen_size.x + sprite_width or \
	position.y > screen_size.y + sprite_height or position.y < 0 - sprite_height:
		queue_free()
		Level.start_enemy_spawner()

func change_direction():
	var rand_angle = randf_range(-PI/4, PI/4)
	velocity = Vector2.RIGHT.rotated(rand_angle)

func _on_engine_noise_finished() -> void:
	$EngineNoise.play()
	
func start_change_dir_timer():
	change_direction()
	$ChangeDirectionTimer.wait_time = randi_range(2, 5)
	$ChangeDirectionTimer.start()
	
func explode():
	$Sprite2D.visible = false
	$EngineNoise.stop()
	$Explosion.emitting = true
	$ExplosionSound.play()


func _on_explosion_finished() -> void:
	queue_free()
