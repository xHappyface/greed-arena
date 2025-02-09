extends Path3D
class_name Toss

@onready var toss_object: Area3D = $PathFollow3D/TossObject
@onready var toss_point: PathFollow3D = $PathFollow3D

var player: Player = null

enum TossObject {
	COIN,
	MONEYBAG,
}

static var object_weights: Dictionary = {
	TossObject.COIN: 40,
	TossObject.MONEYBAG: 10,
}

const COIN_VALUE: int = 50
const MONEYBAG_VALUE: int = 300

var toss_object_type: TossObject = TossObject.COIN

static func create_new(object_type: TossObject = TossObject.COIN) -> Toss:
	var toss: Toss = load("res://scene/toss.tscn").instantiate()
	match object_type:
		TossObject.MONEYBAG:
			var toss_object: Area3D = toss.find_child("TossObject")
			for child in toss_object.get_children():
				child.hide()
				child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			toss_object.find_child("MoneyBag").show()
			toss_object.find_child("MoneyBag").physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			toss_object.find_child("MoneyBagCollisionShape").show()
			toss_object.find_child("MoneyBagCollisionShape").physics_interpolation_mode = \
			  Node.PHYSICS_INTERPOLATION_MODE_ON
		_:
			pass
	toss.toss_object_type = object_type
	return toss

static func random_toss_object() -> TossObject:
	var total_weight: int = 0
	for weight in object_weights.values():
		total_weight += weight
	var rand: int = randi_range(0, total_weight)
	for obj in object_weights.keys():
		if rand <= object_weights[obj]:
			return obj
		else:
			rand -= object_weights[obj]
	return TossObject.COIN

func _physics_process(_delta: float) -> void:
	if player and toss_object.overlaps_body(player):
		queue_free()
		match toss_object_type:
			TossObject.MONEYBAG:
				player.money += MONEYBAG_VALUE
			_:
				player.money += COIN_VALUE
		print(player.money)
