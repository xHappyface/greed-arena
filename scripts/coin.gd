extends Path3D
class_name CoinToss

@onready var coin: Area3D = $PathFollow3D/Coin
@onready var toss_point: PathFollow3D = $PathFollow3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var player: Player = null

func _ready() -> void:
	player = get_parent().get_parent().find_child("Player")

func _physics_process(delta: float) -> void:
	if player and coin.overlaps_body(player):
		queue_free()
		player.money += 500
		print(player.money)
