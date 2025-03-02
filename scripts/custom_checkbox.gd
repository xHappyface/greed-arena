extends Button
class_name CustomCheckbox

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		theme_type_variation = "_Checked"
	else:
		theme_type_variation = ""
