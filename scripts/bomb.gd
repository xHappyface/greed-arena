extends RigidBody3D
class_name Bomb

@export var shock_curve: Curve
@export var air_resistance_curve: Curve

@onready var shockwave: Area3D = $Shockwave
@onready var blast: Area3D = $Blast

func _explode() -> void:
	var shockwave_bodies: Array[Node3D] = shockwave.get_overlapping_bodies()
	var blast_bodies: Array[Node3D] = blast.get_overlapping_bodies()
	for body in blast_bodies:
		if body is Player:
			if blast_bodies.has(body):
				print("GAME OVER")
				LevelProvider.level.level_manager.get_parent().stop_game()
	for body in shockwave_bodies:
		if body is RigidBody3D:
			print("@@@@@@@@@@@@@@@@@@@@@@@")
			var shockwave_radius: float = shockwave.get_child(0).shape.radius
			var distance_away: float = \
			  (shockwave_radius - global_position.distance_to(body.global_position)) / shockwave_radius
			body.apply_impulse((body.global_position - global_position).normalized() * 225.0 * \
			  shock_curve.sample(distance_away))
