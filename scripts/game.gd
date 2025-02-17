extends Node
class_name Game

@onready var save_file_resource: Resource = preload("res://scripts/save_file.gd")

@onready var level_manager: LevelManager = $LevelManager
@onready var ui: Control = $LevelManager/UI
@onready var main_menu: MainMenu = $Menu/MainMenu
@onready var options_menu: OptionsMenu = $Menu/OptionsMenu

var active_game: bool = false

func _init() -> void:
	LevelProvider.save_file = SaveFile.load_game()

func _ready() -> void:
	get_tree().paused = true
	options_menu.audio_volume_slider.value = LevelProvider.save_file.options_audio_volume
	options_menu.audio_mute_checkbox.button_pressed = LevelProvider.save_file.options_audio_mute

func _process(_delta: float) -> void:
	var scene_tree: SceneTree = get_tree()
	var pressed_esc: bool = Input.is_action_just_pressed("game_escape")
	if active_game and not scene_tree.paused and pressed_esc:
		scene_tree.paused = true
		ui.pause_screen.show()
	elif active_game and scene_tree.paused and pressed_esc:
		ui.pause_screen.hide()
		scene_tree.paused = false

func start_game() -> void:
	active_game = true
	LevelProvider.level.player.money = 0
	LevelProvider.level.player.speed = LevelProvider.level.player.BASE_SPEED + \
	  (LevelProvider.speed_rank * LevelProvider.level.player.SPEED_GROWTH_RATE)
	ui.update_money()
	main_menu.hide()
	get_tree().paused = false

func stop_game() -> void:
	active_game = false
	get_tree().paused = true
	LevelProvider.save_file.money += LevelProvider.level.player.money
	main_menu.display_last_earned(LevelProvider.level.player.money)
	LevelProvider.level.queue_free()
	level_manager.load_level()
	main_menu.show()
	LevelProvider.save_file.save_game()
