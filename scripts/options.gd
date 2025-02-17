extends Control
class_name OptionsMenu

@onready var audio_volume_slider: HSlider = $VBoxContainer/Volume/HSlider
@onready var audio_mute_checkbox: CheckBox = $VBoxContainer/Mute/CheckBox

static func set_mute(state: bool) -> void:
	AudioServer.set_bus_mute(0, state)

static func set_volume(percent: float) -> void:
	var db: float = -55.0 + ((55.0 / 100.0) * percent)
	AudioServer.set_bus_volume_db(0, db)

func save_options_and_go_back() -> void:
	LevelProvider.save_file.options_audio_volume = audio_volume_slider.value
	LevelProvider.save_file.options_audio_mute = audio_mute_checkbox.button_pressed
	LevelProvider.save_file.save_game()
	get_parent().switch_to_main()
