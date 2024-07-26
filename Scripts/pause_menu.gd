extends CenterContainer

@onready var GameOver = get_node("/root/Main/GameOver")
@onready var LevelStart = get_node("/root/Main/LevelStart")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not GameOver.visible and not LevelStart.visible:
		if get_tree().paused:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_new_game_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
