extends CanvasLayer


@export var game_level: PackedScene

func _on_button_pressed() -> void:
	var game = game_level.instantiate()
	#var main = get_tree().current_scene
	
	get_parent().add_child(game)
	
	queue_free()
