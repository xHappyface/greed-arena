extends CharacterBody3D
class_name Player

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var camera: Camera3D = null
var camera_ray: RayCast3D = null
var money: int = 0

func _ready() -> void:
	camera = get_parent().find_child("Camera3D")
	camera_ray = camera.find_child("RayCast3D")

func _physics_process(delta: float) -> void:
	if nav.is_navigation_finished():
		if LevelProvider.level.ground_marker.visible:
			LevelProvider.level.ground_marker.hide()
		return
	else:
		look_at(nav.target_position)
		velocity = delta * global_position.direction_to(nav.target_position) * 1_000.0
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_pos: Vector2 = event.position
		camera_ray.global_position = camera.project_ray_origin(mouse_pos)
		camera_ray.target_position = camera.project_ray_normal(mouse_pos) * camera.far
		camera_ray.force_raycast_update()
		if camera_ray.is_colliding() and camera_ray.get_collider().is_in_group("Arena"):
			var collision_point: Vector3 = camera_ray.get_collision_point()
			nav.target_position = Vector3(collision_point.x, 0.0, collision_point.z)
			LevelProvider.level.ground_marker.position = nav.target_position
			if not LevelProvider.level.ground_marker.visible:
				LevelProvider.level.ground_marker.show()
