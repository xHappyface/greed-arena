extends Area3D
class_name Money

var is_attracted_to_player: bool = false

func _physics_process(delta: float) -> void:
	if is_attracted_to_player:
		global_position = global_position.move_toward(LevelProvider.level.player.global_position, 10.0 * delta)
