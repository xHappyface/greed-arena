extends CharacterBody3D
class_name Player

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var magnetic_field: Area3D = $MagneticField

var camera: Camera3D = null
var camera_ray: RayCast3D = null

const BASE_SPEED: float = 1_000.0
const SPEED_GROWTH_RATE: float = 100.0

var money: int = 0
var speed: float = BASE_SPEED
var held_items: Array[Toss.TossObject] = []

static func get_real_speed() -> float:
	return BASE_SPEED + (LevelProvider.ranks[LevelProvider.Rank.SPEED] * SPEED_GROWTH_RATE)

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
		velocity = delta * global_position.direction_to(nav.target_position) * speed
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
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if held_items.size() > 0:
			var item: Toss.TossObject = held_items.pop_front()
			if LevelProvider.level.level_manager.ui.held_item_slots.get_child(0).get_child(0).visible:
				LevelProvider.level.level_manager.ui.held_item_slots.get_child(0).get_child(0).hide()
			else:
				LevelProvider.level.level_manager.ui.held_item_slots.get_child(1).get_child(0).hide()
			match item:
				_:
					LevelProvider.slow_time()

func set_player_magnetism(rank: int) -> void:
	match rank:
		3:
			magnetic_field.monitoring = true
			magnetic_field.visible = true
			magnetic_field.find_child("CollisionShape3D").shape.radius = 2.87
			magnetic_field.find_child("Magnet").scale = Vector3(2.0, 1.35, 2.0)
		2:
			magnetic_field.monitoring = true
			magnetic_field.visible = true
			magnetic_field.find_child("CollisionShape3D").shape.radius = 2.5
			magnetic_field.find_child("Magnet").scale = Vector3(1.67, 1.3, 1.67)
		1:
			magnetic_field.monitoring = true
			magnetic_field.visible = true
			magnetic_field.find_child("CollisionShape3D").shape.radius = 1.87
			magnetic_field.find_child("Magnet").scale = Vector3(1.25, 1.25, 1.25)
		_:
			magnetic_field.monitoring = false
			magnetic_field.visible = false

func _on_magnetic_field_area_entered(area: Area3D) -> void:
	if area is Money:
		area.is_attracted_to_player = true

func _on_magnetic_field_area_exited(area: Area3D) -> void:
	if area is Money:
		area.is_attracted_to_player = false
