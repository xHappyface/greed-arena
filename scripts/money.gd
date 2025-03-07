extends Area3D
class_name Money

@export var attraction_curve: Curve

var is_attracted_to_player: bool = false

func _physics_process(delta: float) -> void:
	if is_attracted_to_player:
		var player = LevelProvider.level.player
		var field_radius: float = player.magnetic_field.find_child("CollisionShape3D").shape.radius
		var multiplier: float = attraction_curve.sample((field_radius - global_position.distance_to(player.global_position)) / field_radius)
		global_position = global_position.move_toward(player.global_position, 14.0 * delta * multiplier)
