extends CenterContainer

@onready var LevelContainer = get_node("/root/Main/LevelContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	open()
	

func _unhandled_key_input(event: InputEvent) -> void:
	if visible:
		visible = false
		get_tree().paused = false

func open() -> void:
	get_tree().paused = true
	visible = true
	$PanelContainer/MarginContainer/VBoxContainer/Label.text = "Level " + str(LevelContainer.current_level)
