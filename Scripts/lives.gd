extends Node2D

const INITIAL_EXTRA_LIVES_COUNT = 2
var lives = []
@onready var life_scene = preload("res://Scenes/life.tscn")
@onready var game_over = get_node("/root/Main/GameOver")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_a_life()
	add_a_life()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_a_life():
	var life = life_scene.instantiate()
	life.position.x = lives.size() * 48
	life.position.y = 0
	add_child(life)
	lives.push_back(life)
	
func remove_a_life():
	var life = lives.pop_back()
	if life:
		life.queue_free()
	else:
		game_over.visible = true

func _on_level_container_restart_game() -> void:
	add_a_life()
	add_a_life()
