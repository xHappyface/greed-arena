extends CharacterBody3D
class_name Player

var camera: Camera3D = null
var camera_ray: RayCast3D = null
var destination: Vector3 = Vector3.ZERO
var money: int = 0

func _ready() -> void:
	destination = global_position
	camera = get_parent().find_child("Camera3D")
	camera_ray = camera.find_child("RayCast3D")

func _physics_process(delta: float) -> void:
	if global_position.distance_to(destination) > 0.25:
		velocity = -transform.basis.z * 3_000.0 * delta
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_pos: Vector2 = event.position
		camera_ray.global_position = camera.project_ray_origin(mouse_pos)
		camera_ray.target_position = camera.project_ray_normal(mouse_pos) * camera.far
		camera_ray.force_raycast_update()
		if camera_ray.is_colliding():
			var collision_point: Vector3 = camera_ray.get_collision_point()
			destination = Vector3(collision_point.x, 0.0, collision_point.z)
			look_at(destination)
