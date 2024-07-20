extends Node2D

var level1 = preload("res://Scenes/level1.tscn")
var level2 = preload("res://Scenes/level2.tscn")
var level3 = preload("res://Scenes/level3.tscn")
var levels = [level1, level2, level3]
var current_level = 1
signal restart_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_current_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_current_level():
	var level_scene = levels[current_level - 1]
	var level = level_scene.instantiate()
	add_child(level)

func _on_new_game_button_pressed() -> void:
	current_level = 1
	remove_child(get_child(0))
	load_current_level()
	restart_game.emit()