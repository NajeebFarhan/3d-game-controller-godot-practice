extends Node3D

@export var bullet_speed: float = 5.0
@export var max_distance: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bullet_velocity = Vector3(0.0, 0.0, -bullet_speed)
	position += basis * bullet_velocity * delta
	

func _on_dispawn_timer_timeout() -> void:
	queue_free()
