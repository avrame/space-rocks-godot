extends Node2D

@onready var EnemyShip = preload("res://Scenes/enemy-ship.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_enemy_spawner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_enemy_spawner():
	var enemy_timeout = randi_range(5, 30)
	$EnemySpawner.wait_time = enemy_timeout
	$EnemySpawner.start()


func _on_enemy_spawner_timeout() -> void:
	var enemy_ship = EnemyShip.instantiate()
	add_child(enemy_ship)
