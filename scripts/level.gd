extends Node3D
class_name Level

@onready var arena: StaticBody3D = $Arena
@onready var player: Player = $Player
@onready var game_timer: Timer = $GameTimer
@onready var tossers: Node = $Tossers

var level_manager: LevelManager = null

func _on_coin_spawner_timeout() -> void:
	if not level_manager:
		return
	var arena_mesh: MeshInstance3D = arena.find_child("MeshInstance3D")
	var spawn_point: Vector3 = Vector3(randf_range(-arena_mesh.mesh.size.x / 2.0, arena_mesh.mesh.size.x / 2.0), \
	  0.0, randf_range(-arena_mesh.mesh.size.y / 2.0, arena_mesh.mesh.size.y / 2.0))
	var toss: Toss = Toss.create_new(Toss.random_toss_object())
	var tosser: Node3D = tossers.get_children().pick_random()
	tosser.add_child(toss)
	toss.position = tosser.position
	toss.curve.set("point_1/position", -tosser.position + spawn_point)
	print("spawn: %s\ntarget: %s\n" % [toss.global_position, \
	  toss.curve.get("point_1/position")])
	toss.player = player
	toss.toss_object.connect("tree_exited", level_manager.ui._on_coin_collected)
