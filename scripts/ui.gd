extends Control
class_name UI

@onready var pocketwatch_icon: CompressedTexture2D = preload("res://assets/images/stopwatch_icon.png")
@onready var shield_icon: CompressedTexture2D = preload("res://assets/images/shield_icon.png")

@onready var stats: VBoxContainer = $Stats
@onready var money: Label = $Stats/Money
@onready var time: Label = $Stats/Time
@onready var pause_screen: Label = $Paused
@onready var held_item_slot1: TextureRect = $HeldItemSlots/ItemSlot1/Icon
@onready var held_item_slot2: TextureRect = $HeldItemSlots/ItemSlot2/Icon

@onready var icons: Dictionary = {
	Toss.TossObject.POCKETWATCH: pocketwatch_icon,
	Toss.TossObject.SHIELD: shield_icon,
}

func _ready() -> void:
	money.text = "$%s" % [Util.human_readable_number(LevelProvider.save_file.money)]

func _physics_process(_delta: float) -> void:
	if LevelProvider.level:
		update_time()

func update_money() -> void:
	money.text = "$%s" % [Util.human_readable_number(LevelProvider.level.player.money)]
	queue_redraw()

func update_time() -> void:
	var time_left: float = LevelProvider.level.game_timer.time_left
	time.text = "%d:%02d" % [time_left / 60.0, int(time_left) % 60]
	queue_redraw()

func add_held_item(item: Toss.TossObject) -> void:
	if Toss.held_items.has(item):
		update_money()
		if not held_item_slot2.visible:
			LevelProvider.level.player.held_items.append(item)
			if not held_item_slot1.visible:
				held_item_slot1.texture = icons[item]
				held_item_slot1.show()
			else:
				held_item_slot2.texture = icons[item]
				held_item_slot2.show()
			print("held items:")
			for i in LevelProvider.level.player.held_items:
				print(i)
