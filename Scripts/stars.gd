extends Node2D

var star_scene = preload("res://Scenes/star.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_width = get_viewport_rect().size.x
	var viewport_height = get_viewport_rect().size.y
	for i in range(500):
		var star = star_scene.instantiate()
		var x_pos = randi_range(0, viewport_width)
		var y_pos = randi_range(0, viewport_height)
		var frame_num = floor(randfn(7.5, 2.5))
		if frame_num < 0:
			frame_num = 0
		elif frame_num > 15:
			frame_num = 15
		
		star.position = Vector2(x_pos, y_pos)
		star.frame = frame_num
		add_child(star)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
