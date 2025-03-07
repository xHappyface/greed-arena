extends Control
class_name ShopMenu

@onready var shop_items: GridContainer = $VBoxContainer/ShopItems
@onready var speed_item_card: ItemCard = $VBoxContainer/ShopItems/SpeedItemCard
@onready var time_item_card: ItemCard = $VBoxContainer/ShopItems/TimeItemCard
@onready var magnet_item_card: ItemCard = $VBoxContainer/ShopItems/MagnetItemCard
@onready var money_bundle_upgrade_card: ItemCard = $VBoxContainer/ShopItems/MoneyBundleUpgradeCard
@onready var money_bag_upgrade_card: ItemCard = $VBoxContainer/ShopItems/MoneyBagUpgradeCard
@onready var back_button: Button = $VBoxContainer/BackButton

@export var items: Array[ShopItem] = []

func _ready() -> void:
	_update_speed_card()
	_update_time_card()
	_update_magnet_card()
	_update_money_bundle_card()
	_update_money_bag_card()
	speed_item_card.button.pressed.connect(increment_rank.bind(LevelProvider.Rank.SPEED))
	time_item_card.button.pressed.connect(increment_time_rank)
	magnet_item_card.button.pressed.connect(increment_rank.bind(LevelProvider.Rank.MAGNET))
	money_bundle_upgrade_card.button.pressed.connect(increment_rank.bind(LevelProvider.Rank.MONEY_BUNDLE))
	money_bag_upgrade_card.button.pressed.connect(increment_rank.bind(LevelProvider.Rank.MONEY_BAG))

func increment_rank(rank: LevelProvider.Rank) -> void:
	var max_rank: int = 0
	var update_card: Callable = Callable()
	match rank:
		LevelProvider.Rank.MAGNET:
			max_rank = LevelProvider.MAGNET_RANKS
			update_card = _update_magnet_card
		LevelProvider.Rank.MONEY_BUNDLE:
			max_rank = LevelProvider.MONEY_BUNDLE_RANKS
			update_card = _update_money_bundle_card
			Toss.set_money_weights()
		LevelProvider.Rank.MONEY_BAG:
			max_rank = LevelProvider.MONEY_BAG_RANKS
			update_card = _update_money_bag_card
			Toss.set_money_weights()
		_:
			max_rank = LevelProvider.SPEED_RANKS
			update_card = _update_speed_card
	if LevelProvider.save_file.money >= 100_000 and \
	  LevelProvider.ranks[rank] != max_rank:
		_charge_player(100_000)
		LevelProvider.ranks[rank] += 1
		LevelProvider.ranks[rank] = clamp(LevelProvider.ranks[rank], 0, max_rank)
		update_card.call()
		LevelProvider.save_file.save_game()

func increment_time_rank() -> void:
	if LevelProvider.save_file.money >= 100_000 and LevelProvider.ranks[LevelProvider.Rank.TIME] != LevelProvider.TIME_RANKS:
		_charge_player(100_000)
		LevelProvider.ranks[LevelProvider.Rank.TIME] += 1
		LevelProvider.ranks[LevelProvider.Rank.TIME] = clamp(LevelProvider.ranks[LevelProvider.Rank.TIME], 0, LevelProvider.TIME_RANKS)
		LevelProvider.update_game_timer()
		get_parent().get_parent().ui.update_time()
		_update_time_card()
		LevelProvider.save_file.save_game()

func _charge_player(cost: int) -> void:
	LevelProvider.save_file.money -= cost
	LevelProvider.level.player.money = LevelProvider.save_file.money
	get_parent().get_parent().ui.update_money()

func _update_speed_card() -> void:
	speed_item_card.label.text = "Speed Increase\n(Rank %d)" % \
	  [LevelProvider.ranks[LevelProvider.Rank.SPEED] + 1]
	queue_redraw()

func _update_time_card() -> void:
	time_item_card.label.text = "Extra Time\n(Rank %d)" % \
	  [LevelProvider.ranks[LevelProvider.Rank.TIME] + 1]
	queue_redraw()

func _update_magnet_card() -> void:
	magnet_item_card.label.text = "Magnet\n(Rank %d)" % \
	  [LevelProvider.ranks[LevelProvider.Rank.MAGNET] + 1]
	queue_redraw()

func _update_money_bundle_card() -> void:
	money_bundle_upgrade_card.label.text = "Money Bundle\n(Rank %d)" % \
	  [LevelProvider.ranks[LevelProvider.Rank.MONEY_BUNDLE] + 1]
	queue_redraw()

func _update_money_bag_card() -> void:
	money_bag_upgrade_card.label.text = "Money Bag\n(Rank %d)" % \
	  [LevelProvider.ranks[LevelProvider.Rank.MONEY_BAG] + 1]
	queue_redraw()
