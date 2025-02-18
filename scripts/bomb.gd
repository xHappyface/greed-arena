extends RigidBody3D
class_name Bomb

func _physics_process(delta: float) -> void:
	if constant_force !=  Vector3.ZERO:
		constant_force = constant_force.move_toward(Vector3.ZERO, 750.0 * delta)
