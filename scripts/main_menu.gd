extends Control
class_name MainMenu

@onready var title: Label = $VBoxContainer/Title
@onready var last_earned: Label = $VBoxContainer/LastEarned
@onready var last_earned_spacer: Control = $VBoxContainer/Spacer128Y
@onready var last_time: Label = $VBoxContainer/LastTime
@onready var last_time_space: Control = $VBoxContainer/Spacer8Y3

@onready var buttons: Array[Button] = [
	$VBoxContainer/PlayButton,
	$VBoxContainer/ShopButton,
	$VBoxContainer/OptionsButton,
]

func display_last_stats(money: int) -> void:
	last_earned.text = "Last Earned: $%s" % [Util.human_readable_number(money)]
	last_time.text = "Last Time: %02d:%02d" % \
	  [int(LevelProvider.last_time) / 60, LevelProvider.last_time % 60]
	queue_redraw()
	if not last_earned.visible:
		last_earned.show()
		last_earned_spacer.show()
		last_time.show()
		last_time_space.show()
