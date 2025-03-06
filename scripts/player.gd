extends CharacterBody3D
class_name Player

@onready var yarn_ball: Node3D = $YarnBall
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var magnetic_field: Area3D = $MagneticField
@onready var shield: Node3D = $Shield
@onready var shield_timer: Timer = $Shield/Timer

enum InputControls {
	MOUSE,
	KEYBOARD,
	GAMEPAD,
}

static var input_controls: InputControls = InputControls.MOUSE

var camera: Camera3D = null
var camera_ray: RayCast3D = null

const BASE_SPEED: float = 850.0
const SPEED_GROWTH_RATE: float = 75.0

var money: int = 0
var speed: float = BASE_SPEED
var held_items: Array[Toss.TossObject] = []

static func get_real_speed() -> float:
	return BASE_SPEED + (LevelProvider.ranks[LevelProvider.Rank.SPEED] * SPEED_GROWTH_RATE)

func _ready() -> void:
	camera = get_parent().find_child("Camera3D")
	camera_ray = camera.find_child("RayCast3D")

func _physics_process(delta: float) -> void:
	shield.global_position = Vector3(global_position.x, 0.6, global_position.z)
	match input_controls:
		InputControls.KEYBOARD:
			_handle_keyboard_movement(delta)
			if Input.is_action_just_pressed("keyboard_action"):
				_use_item()
		InputControls.GAMEPAD:
			_handle_gamepad_movement(delta)
			if Input.is_action_just_pressed("gamepad_action"):
				_use_item()
		_:
			if nav.is_navigation_finished():
				if LevelProvider.level.ground_marker.visible:
					LevelProvider.level.ground_marker.hide()
				return
			else:
				_handle_mouse_movement(delta)
	if not (velocity == Vector3.ZERO):
		yarn_ball.rotation_degrees.x -= Vector3.ZERO.distance_to(velocity) * 0.5
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not input_controls == InputControls.MOUSE:
		return
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
		_use_item()

func take_hit() -> void:
	if shield.visible:
		shield_timer.stop()
		shield.hide()
	else:
		print("GAME OVER")
		LevelProvider.level.level_manager.get_parent().stop_game()

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

func _handle_mouse_movement(delta: float) -> void:
	look_at(nav.target_position)
	velocity = delta * global_position.direction_to(nav.target_position) * speed

func _handle_keyboard_movement(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("keyboard_left", "keyboard_right", "keyboard_down", "keyboard_up", 0.25).normalized()
	if not move_dir.is_zero_approx():
		look_at(global_position + Vector3(move_dir.y, 0.0, move_dir.x))
		velocity = delta * Vector3(move_dir.y, 0.0, move_dir.x) * speed

func _handle_gamepad_movement(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("gamepad_left", "gamepad_right", "gamepad_down", "gamepad_up", 0.25).normalized()
	if not move_dir.is_zero_approx():
		look_at(global_position + Vector3(move_dir.y, 0.0, move_dir.x))
		velocity = delta * Vector3(move_dir.y, 0.0, move_dir.x) * speed

func _use_item() -> void:
	if held_items.size() > 0:
		var item: Toss.TossObject = held_items.pop_front()
		if LevelProvider.level.level_manager.ui.held_item_slot2.visible:
			LevelProvider.level.level_manager.ui.held_item_slot2.hide()
			LevelProvider.level.level_manager.ui.held_item_slot1.texture = \
			  LevelProvider.level.level_manager.ui.held_item_slot2.texture
		else:
			LevelProvider.level.level_manager.ui.held_item_slot1.hide()
		match item:
			Toss.TossObject.SHIELD:
				shield_timer.stop()
				if not shield.visible:
					shield.show()
				shield_timer.start()
			_:
				LevelProvider.slow_time()

func _on_magnetic_field_area_entered(area: Area3D) -> void:
	if area is Money:
		area.is_attracted_to_player = true

func _on_magnetic_field_area_exited(area: Area3D) -> void:
	if area is Money:
		area.is_attracted_to_player = false

func _hide_shield() -> void:
	shield.hide()
