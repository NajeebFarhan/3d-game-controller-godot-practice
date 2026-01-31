extends Node3D

@export var bullet_scn: PackedScene

@onready var bullet_spawn_marker = $BulletSpawnPoint
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var bullet = bullet_scn.instantiate()
		bullet.position = bullet_spawn_marker.global_position
		bullet.basis = global_basis
	
	#get_tree().add_child(bullet)
		get_tree().current_scene.add_child(bullet)
