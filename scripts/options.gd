extends Control
class_name OptionsMenu

func set_mute(state: bool) -> void:
	AudioServer.set_bus_mute(0, state)

func set_volume(percent: float) -> void:
	var db: float = -55.0 + ((55.0 / 100.0) * percent)
	AudioServer.set_bus_volume_db(0, db)
