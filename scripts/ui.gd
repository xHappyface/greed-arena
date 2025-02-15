extends Control
class_name UI

@onready var money: Label = $VBoxContainer/Money
@onready var time: Label = $VBoxContainer/Time

var player: Player = null

func _ready() -> void:
	money.text = "$%s" % [_human_readable_number(LevelProvider.save_file.money)]

func _physics_process(_delta: float) -> void:
	if LevelProvider.level:
		var time_left: float = LevelProvider.level.game_timer.time_left
		time.text = "%d:%02d" % [time_left / 60.0, int(time_left) % 60]
		queue_redraw()

func _on_coin_collected() -> void:
	if player:
		money.text = "$%s" % [_human_readable_number(player.money)]
		queue_redraw()

func _human_readable_number(number: int) -> String:
	var formatted_number: String = ("%d" % [number]).reverse()
	var regex: RegEx = RegEx.new()
	regex.compile(".{1,3}")
	var regex_matches: Array[RegExMatch] = regex.search_all(formatted_number)
	var arr: Array[String] = []
	for regex_match in regex_matches:
		arr.append(regex_match.get_string())
	formatted_number = ",".join(arr).reverse()
	return formatted_number
