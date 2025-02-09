extends Control
class_name UI

@onready var money: Label = $VBoxContainer/Money
@onready var time: Label = $VBoxContainer/Time

var level_manager: LevelManager = null
var player: Player = null

func _ready() -> void:
	level_manager = get_parent()

func _physics_process(_delta: float) -> void:
	if level_manager.level:
		var time_left: float = level_manager.level.game_timer.time_left
		time.text = "%d:%02d" % [time_left / 60.0, int(time_left) % 60]
		queue_redraw()

func _on_coin_collected() -> void:
	if player:
		money.text = "$%.02f" % [player.money / 100.0]
		queue_redraw()
