extends Control
class_name ShopMenu

@onready var shop_items: GridContainer = $VBoxContainer/ShopItems
@onready var speed_item_card: ItemCard = $VBoxContainer/ShopItems/SpeedItemCard
@onready var time_item_card: ItemCard = $VBoxContainer/ShopItems/TimeItemCard

@export var items: Array[ShopItem] = []

func _ready() -> void:
	_update_speed_card()
	_update_time_card()
	speed_item_card.button.pressed.connect(increment_speed_rank)
	time_item_card.button.pressed.connect(increment_time_rank)

func increment_speed_rank() -> void:
	if LevelProvider.save_file.money >= 100_000:
		_charge_player(100_000)
		LevelProvider.speed_rank += 1
		LevelProvider.speed_rank = clamp(LevelProvider.speed_rank, 0, LevelProvider.SPEED_RANKS)
		_update_speed_card()
		LevelProvider.save_file.save_game()

func increment_time_rank() -> void:
	if LevelProvider.save_file.money >= 100_000:
		_charge_player(100_000)
		LevelProvider.time_rank += 1
		LevelProvider.time_rank = clamp(LevelProvider.time_rank, 0, LevelProvider.TIME_RANKS)
		LevelProvider.update_game_timer()
		get_parent().get_parent().ui.update_time()
		_update_time_card()
		LevelProvider.save_file.save_game()

func _charge_player(cost: int) -> void:
	LevelProvider.save_file.money -= cost
	LevelProvider.level.player.money = LevelProvider.save_file.money
	get_parent().get_parent().ui.update_money()

func _update_speed_card() -> void:
	speed_item_card.label.text = "Speed Increase\n(Rank %d)" % [LevelProvider.speed_rank + 1]
	queue_redraw()

func _update_time_card() -> void:
	time_item_card.label.text = "Extra Time\n(Rank %d)" % [LevelProvider.time_rank + 1]
	queue_redraw()
