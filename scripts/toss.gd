extends Path3D
class_name Toss

@onready var coin_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/coin.wav")
@onready var moneybag_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/coin_in_purse.wav")

@onready var toss_object: Area3D = $PathFollow3D/TossObject
@onready var toss_point: PathFollow3D = $PathFollow3D

enum TossObject {
	COIN,
	MONEYBUNDLE,
	MONEYBAG,
	POCKETWATCH,
	SHIELD,
}

static var object_weights: Dictionary = {
	TossObject.COIN: 50,
	TossObject.MONEYBUNDLE: 8,
	TossObject.MONEYBAG: 3,
	TossObject.POCKETWATCH: 2,
	TossObject.SHIELD: 2,
}

static var held_items: Dictionary = {
	TossObject.POCKETWATCH: true,
	TossObject.SHIELD: true,
}

const COIN_VALUE: int = 100
const MONEYBUNDLE_VALUE = 1_000
const MONEYBAG_VALUE: int = 6_000

var toss_object_type: TossObject = TossObject.COIN

static func create_new(object_type: TossObject = TossObject.COIN) -> Toss:
	var toss: Toss = load("res://scene/toss.tscn").instantiate()
	var toss_obj: Area3D = toss.find_child("TossObject")
	match object_type:
		TossObject.MONEYBUNDLE:
			for child in toss_obj.get_children():
				child.hide()
				child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			toss_obj.find_child("MoneyBundle").show()
			toss_obj.find_child("MoneyBundle").physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			toss_obj.find_child("MoneyBundleCollisionShape").show()
			toss_obj.find_child("MoneyBundleCollisionShape").physics_interpolation_mode = \
			  Node.PHYSICS_INTERPOLATION_MODE_ON
		TossObject.MONEYBAG:
			for child in toss_obj.get_children():
				child.hide()
				child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			toss_obj.find_child("MoneyBag").show()
			toss_obj.find_child("MoneyBag").physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			toss_obj.find_child("MoneyBagCollisionShape").show()
			toss_obj.find_child("MoneyBagCollisionShape").physics_interpolation_mode = \
			  Node.PHYSICS_INTERPOLATION_MODE_ON
		TossObject.POCKETWATCH:
			for child in toss_obj.get_children():
				child.hide()
				child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			toss_obj.find_child("PocketWatch").show()
			toss_obj.find_child("PocketWatch").physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			toss_obj.find_child("PocketWatchCollisionShape").show()
			toss_obj.find_child("PocketWatchCollisionShape").physics_interpolation_mode = \
			  Node.PHYSICS_INTERPOLATION_MODE_ON
		TossObject.SHIELD:
			for child in toss_obj.get_children():
				child.hide()
				child.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			toss_obj.find_child("Shield").show()
			toss_obj.find_child("Shield").physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			toss_obj.find_child("ShieldCollisionShape").show()
			toss_obj.find_child("ShieldCollisionShape").physics_interpolation_mode = \
			  Node.PHYSICS_INTERPOLATION_MODE_ON
		_:
			pass
	toss.toss_object_type = object_type
	return toss

static func set_money_weights() -> void:
	var money_bundle_rank: int = LevelProvider.ranks[LevelProvider.Rank.MONEY_BUNDLE]
	var money_bag_rank: int = LevelProvider.ranks[LevelProvider.Rank.MONEY_BAG]
	match money_bundle_rank:
		3:
			object_weights[TossObject.MONEYBUNDLE] = 21
		2:
			object_weights[TossObject.MONEYBUNDLE] = 15
		1:
			object_weights[TossObject.MONEYBUNDLE] = 12
		_:
			pass
	object_weights[TossObject.MONEYBAG] += money_bag_rank * 2

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		queue_free()
		match toss_object_type:
			TossObject.MONEYBUNDLE:
				LevelProvider.level.player.money += MONEYBUNDLE_VALUE
			TossObject.MONEYBAG:
				LevelProvider.level.player.money += MONEYBAG_VALUE
			_:
				LevelProvider.level.player.money += COIN_VALUE
		_drop_sfx()
		print(LevelProvider.level.player.money)

func _drop_sfx() -> void:
	var drop_sfx: AudioStreamWAV = null
	match toss_object_type:
		TossObject.MONEYBAG:
			drop_sfx = moneybag_sfx
		_:
			drop_sfx = coin_sfx
	var drop_sfx_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	drop_sfx_player.stream = drop_sfx
	drop_sfx_player.connect("finished", drop_sfx_player.queue_free)
	drop_sfx_player.set_bus("SFX")
	LevelProvider.level.audio_players.add_child(drop_sfx_player)
	drop_sfx_player.global_position = global_position
	drop_sfx_player.play()

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
