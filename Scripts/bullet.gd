extends Area2D

const speed = 3000
@onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LifeSpanTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.y * speed * delta
	position = global.wrap_around(position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroids"):
		queue_free()
		var asteroid = body.get_parent()
		if asteroid:
			asteroid.explode()


func _on_life_span_timer_timeout() -> void:
	queue_free()
