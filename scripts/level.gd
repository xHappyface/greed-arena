extends Node3D
class_name Level

@export var money_spawner_curve: Curve
@export var money_spawner2_curve: Curve
@export var bomb_spawner_curve: Curve
@export var bomb_spawner2_curve: Curve

@onready var bomb_scene: PackedScene = preload("res://scene/bomb_toss.tscn")

@onready var arena_mesh: MeshInstance3D = $WorldObjects/NavigationRegion3D/MeshInstance3D
@onready var tossers: Node = $Tossers
@onready var game_timer: Timer = $Timers/GameTimer
@onready var money_spawner: Timer = $Timers/MoneySpawner
@onready var money_spawner2: Timer = $Timers/MoneySpawner2
@onready var bomb_spawner: Timer = $Timers/BombSpawner
@onready var bomb_spawner2: Timer = $Timers/BombSpawner2
@onready var player: Player = $Player
@onready var camera: Camera3D = $Camera3D
@onready var ground_marker: Node3D = $GroundMarker

const BASE_GAME_TIME: float = 180.0
const TIME_GROWTH_RATE: float = 15.0

var level_manager: LevelManager = null

func _physics_process(_delta: float) -> void:
	if money_spawner2.is_stopped() and game_timer.time_left <= game_timer.wait_time - 30.0:
		money_spawner2.start()
	if bomb_spawner2.is_stopped() and game_timer.time_left <= game_timer.wait_time - 15.0:
		bomb_spawner2.start()

func _on_money_spawner_timeout() -> void:
	money_spawner.wait_time = money_spawner_curve.sample(game_timer.time_left / game_timer.wait_time)
	var toss: Toss = Toss.create_new(Toss.random_toss_object())
	_spawn_at_random_tosser(toss)
	toss.player = player
	toss.toss_object.connect("tree_exited", level_manager.ui.update_money)
	
func _on_money_spawner2_timeout() -> void:
	money_spawner2.wait_time = money_spawner2_curve.sample(game_timer.time_left / game_timer.wait_time)
	var toss: Toss = Toss.create_new(Toss.random_toss_object())
	_spawn_at_random_tosser(toss)
	toss.player = player
	toss.toss_object.connect("tree_exited", level_manager.ui.update_money)

func _on_bomb_spawner_timeout() -> void:
	bomb_spawner.wait_time = bomb_spawner_curve.sample(game_timer.time_left / game_timer.wait_time)
	var bomb: BombToss = bomb_scene.instantiate()
	_spawn_at_random_tosser(bomb)

func _on_bomb_spawner2_timeout() -> void:
	bomb_spawner2.wait_time = bomb_spawner2_curve.sample(game_timer.time_left / game_timer.wait_time)
	var bomb: BombToss = bomb_scene.instantiate()
	_spawn_at_random_tosser(bomb)

func _spawn_at_random_tosser(toss_scene_instance: Path3D) -> void:
	if not level_manager:
		return
	var tosser: Node3D = tossers.get_children().pick_random()
	tosser.add_child(toss_scene_instance)
	toss_scene_instance.curve.set("point_1/position", -tosser.position + _random_drop_point())
	print("spawn: %s\ntarget: %s\n" % [toss_scene_instance.global_position, \
	  toss_scene_instance.curve.get("point_1/position")])

func _random_drop_point() -> Vector3:
	var half_arena_mesh_side: float = arena_mesh.mesh.size.x / 2.0
	return Vector3(randf_range(-half_arena_mesh_side, half_arena_mesh_side), \
	  0.01, randf_range(-half_arena_mesh_side, half_arena_mesh_side))
