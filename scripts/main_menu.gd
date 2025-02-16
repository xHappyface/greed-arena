extends Control
class_name MainMenu

@onready var last_earned: Label = $VBoxContainer/LastEarned
@onready var last_earned_spacer: Control = $VBoxContainer/Spacer64Y

func display_last_earned(money: int) -> void:
	last_earned.text = "Last Earned: $%s" % [Util.human_readable_number(money)]
	queue_redraw()
	if not last_earned.visible:
		last_earned.show()
		last_earned_spacer.show()
