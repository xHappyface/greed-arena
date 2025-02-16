extends Control
class_name UI

@onready var money: Label = $VBoxContainer/Money
@onready var time: Label = $VBoxContainer/Time

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
