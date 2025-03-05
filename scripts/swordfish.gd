extends Area3D
class_name Swordfish

@export_range(8.0, 90.0, 0.5) var anim_delay: float = 8.0

const Y_HEIGHT: float = 1.0

const SPAWNS: Array[Vector3] = [
	Vector3(0.0, Y_HEIGHT, 60.0),
	Vector3(0.0, Y_HEIGHT, -60.0),
	Vector3(13.25, Y_HEIGHT, 60.0),
	Vector3(13.25, Y_HEIGHT, -60.0),
	Vector3(-13.25, Y_HEIGHT, 60.0),
	Vector3(-13.25, Y_HEIGHT, -60.0),
	Vector3(6.625, Y_HEIGHT, 60.0),
	Vector3(6.625, Y_HEIGHT, -60.0),
	Vector3(-6.625, Y_HEIGHT, 60.0),
	Vector3(-6.625, Y_HEIGHT, -60.0),
]

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_callback(_swim).set_delay(anim_delay)

func _swim() -> void:
	var tween: Tween = create_tween()
	position = SPAWNS.pick_random()
	if sign(position.z) > 0.0:
		rotation_degrees.y = 180.0
	else:
		rotation_degrees.y = 0.0
	tween.tween_property(self, "position", Vector3(position.x, position.y, -position.z), 8.0)
	tween.tween_callback(_swim).set_delay(randf_range(0.0, 4.0))

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.take_hit()
