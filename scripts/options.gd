extends Control
class_name OptionsMenu

@onready var buttons: Array[Button] = [
	$VBoxContainer/Input/OptionButton,
	$VBoxContainer/Mute/CustomCheckbox,
	$VBoxContainer/Resolution/OptionButton,
	$VBoxContainer/FullScreen/CustomCheckbox,
]

@onready var input_controls_option_button: OptionButton = $VBoxContainer/Input/OptionButton
@onready var audio_volume_slider: HSlider = $VBoxContainer/Volume/HSlider
@onready var audio_mute_checkbox: CustomCheckbox = $VBoxContainer/Mute/CustomCheckbox
@onready var resolution_option_button: OptionButton = $VBoxContainer/Resolution/OptionButton

static func set_input_controls(input_control: int) -> void:
	Player.input_controls = input_control

static func set_volume(percent: float) -> void:
	var db: float = -55.0 + ((55.0 / 100.0) * percent)
	AudioServer.set_bus_volume_db(0, db)

static func set_mute(state: bool) -> void:
	AudioServer.set_bus_mute(0, state)

func set_fullscreen(state: bool) -> void:
	if state:
		resolution_option_button.set_disabled(true)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		resolution_option_button.set_disabled(false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func save_options_and_go_back() -> void:
	LevelProvider.save_file.options_input_controls = input_controls_option_button.selected
	LevelProvider.save_file.options_audio_volume = audio_volume_slider.value
	LevelProvider.save_file.options_audio_mute = audio_mute_checkbox.button_pressed
	LevelProvider.save_file.save_game()
	get_parent().switch_to_main()
