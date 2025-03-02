extends Control
class_name UI

@onready var stats: VBoxContainer = $Stats
@onready var money: Label = $Stats/Money
@onready var time: Label = $Stats/Time
@onready var pause_screen: Label = $Paused
@onready var held_item_slots: HBoxContainer = $HeldItemSlots

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
		if not held_item_slots.get_child(0).get_child(0).visible:
			if not held_item_slots.get_child(1).get_child(0).visible:
				held_item_slots.get_child(1).get_child(0).show()
			else:
				held_item_slots.get_child(0).get_child(0).show()
			LevelProvider.level.player.held_items.append(item)
			print("held items:")
			for i in LevelProvider.level.player.held_items:
				print(i)
