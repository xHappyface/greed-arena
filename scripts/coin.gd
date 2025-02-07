extends Path3D
class_name Coin

@onready var coin: Area3D = $PathFollow3D/Coin
@onready var toss_point: PathFollow3D = $PathFollow3D

var player: Player = null

func _physics_process(delta: float) -> void:
	if player and coin.overlaps_body(player):
		queue_free()
		player.money += 500
		print(player.money)
