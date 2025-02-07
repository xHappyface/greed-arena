extends Node3D
class_name Level

@onready var arena: StaticBody3D = $Arena

func _on_coin_spawner_timeout() -> void:
	var coin_toss_scene: PackedScene = preload("res://scene/coin_toss.tscn")
	var arena_mesh: MeshInstance3D = arena.find_child("MeshInstance3D")
	var spawn_point: Vector3 = Vector3(randf_range(-arena_mesh.mesh.size.x / 2.0, arena_mesh.mesh.size.x / 2.0), \
	  0.0, randf_range(-arena_mesh.mesh.size.y / 2.0, arena_mesh.mesh.size.y / 2.0))
	if coin_toss_scene.can_instantiate():
		var coin_toss: Path3D = coin_toss_scene.instantiate()
		$Tosser.add_child(coin_toss)
		coin_toss.curve.set("point_1/position", Vector3(-$Tosser.global_position) + spawn_point)
		print("spawn: %s\ntarget: %s\n" % [coin_toss.global_position, \
		  coin_toss.curve.get("point_1/position")])
