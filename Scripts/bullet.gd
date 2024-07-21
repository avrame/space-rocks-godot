extends Area2D

const speed = 3000
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$LifeSpanTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.y * speed * delta
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroids"):
		queue_free()
		var asteroid = body.get_parent()
		if asteroid:
			asteroid.explode()


func _on_life_span_timer_timeout() -> void:
	queue_free()
