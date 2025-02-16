extends Control
class_name ShopMenu

@onready var shop_items: GridContainer = $VBoxContainer/ShopItems
@onready var speed_item_card: ItemCard = $VBoxContainer/ShopItems/SpeedItemCard
@onready var time_item_card: ItemCard = $VBoxContainer/ShopItems/TimeItemCard

@export var items: Array[ShopItem] = []

func _ready() -> void:
	_update_speed_card()
	_update_time_card()
	speed_item_card.button.pressed.connect(increment_money_rank)
	time_item_card.button.pressed.connect(increment_time_rank)

func increment_money_rank() -> void:
	LevelProvider.speed_rank += 1
	LevelProvider.speed_rank = clamp(LevelProvider.speed_rank, 0, LevelProvider.SPEED_RANKS)
	_update_speed_card()

func increment_time_rank() -> void:
	LevelProvider.time_rank += 1
	LevelProvider.time_rank = clamp(LevelProvider.time_rank, 0, LevelProvider.TIME_RANKS)
	LevelProvider.update_game_timer()
	get_parent().get_parent().ui.update_time()
	_update_time_card()

func _update_speed_card() -> void:
	speed_item_card.label.text = "Speed Increase\n(Rank %d)" % [LevelProvider.speed_rank + 1]
	queue_redraw()

func _update_time_card() -> void:
	time_item_card.label.text = "Extra Time\n(Rank %d)" % [LevelProvider.time_rank + 1]
	queue_redraw()
