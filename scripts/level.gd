extends Node3D
class_name Level

@onready var arena: StaticBody3D = $Arena
@onready var player: Player = $Player
@onready var game_timer: Timer = $GameTimer
@onready var tossers: Node = $Tossers

var level_manager: LevelManager = null

func _on_coin_spawner_timeout() -> void:
	var toss: Toss = Toss.create_new(Toss.random_toss_object())
	_spawn_at_random_tosser(toss)
	toss.player = player
	toss.toss_object.connect("tree_exited", level_manager.ui._on_coin_collected)

func _on_bomb_spawner_timeout() -> void:
	var bomb: Bomb = load("res://scene/bomb_toss.tscn").instantiate()
	bomb.level = self
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
	var arena_mesh: MeshInstance3D = arena.find_child("MeshInstance3D")
	return Vector3(randf_range(-arena_mesh.mesh.size.x / 2.0, arena_mesh.mesh.size.x / 2.0), \
	  0.0, randf_range(-arena_mesh.mesh.size.y / 2.0, arena_mesh.mesh.size.y / 2.0))
