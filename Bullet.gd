extends Area2D

@export var speed = 3000
@onready var trail = $Line2D

func _ready():
	trail.clear_points()
	trail.add_point(Vector2(0, 0))
	trail.add_point(Vector2(0, 20))


func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * speed * delta 
	var screen = get_viewport().get_visible_rect().size
	if global_position.y < -get_viewport().size.y * 0.1:
		queue_free()
	if global_position.x < screen.x * (2.0 / 3.0):
		queue_free() 
