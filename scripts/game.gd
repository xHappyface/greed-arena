extends Node
class_name Game

@onready var save_file_resource: Resource = preload("res://scripts/save_file.gd")

@onready var level_manager: LevelManager = $LevelManager
@onready var ui: Control = $LevelManager/UI
@onready var main_menu: MainMenu = $Menu/MainMenu
@onready var options_menu: OptionsMenu = $Menu/OptionsMenu
@onready var shop_menu: ShopMenu = $Menu/Shop

enum Resolution {
	p1280x720,
	p1920x1080,
	p2560x1440,
	p3840x2160,
}

var resolutions: Dictionary = {
	Resolution.p1280x720: Vector2i(1280, 720),
	Resolution.p1920x1080: Vector2i(1920, 1080),
	Resolution.p2560x1440: Vector2i(2560, 1440),
	Resolution.p3840x2160: Vector2i(3840, 2160),
}

var active_game: bool = false

func _init() -> void:
	LevelProvider.save_file = SaveFile.load_game()

func _ready() -> void:
	get_tree().paused = true
	set_resolution(Resolution.p1280x720)
	options_menu.audio_volume_slider.value = LevelProvider.save_file.options_audio_volume
	options_menu.audio_mute_checkbox.button_pressed = LevelProvider.save_file.options_audio_mute
	Toss.set_money_weights()

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
	Engine.time_scale = 1.0
	LevelProvider.level.player.money = 0
	LevelProvider.level.player.speed = LevelProvider.level.player.BASE_SPEED + \
	  (LevelProvider.ranks[LevelProvider.Rank.SPEED] * LevelProvider.level.player.SPEED_GROWTH_RATE)
	ui.update_money()
	LevelProvider.level.player.set_player_magnetism(LevelProvider.ranks[LevelProvider.Rank.MAGNET])
	main_menu.hide()
	get_tree().paused = false
	print("MONEYBUNDLE RATE: %d" % [Toss.object_weights[Toss.TossObject.MONEYBUNDLE]])
	print("MONEYBAG RATE: %d" % [Toss.object_weights[Toss.TossObject.MONEYBAG]])

func stop_game() -> void:
	active_game = false
	get_tree().paused = true
	LevelProvider.save_file.money += LevelProvider.level.player.money
	LevelProvider.last_time = LevelProvider.level.game_timer.wait_time - \
	  LevelProvider.level.game_timer.time_left
	main_menu.display_last_stats(LevelProvider.level.player.money)
	LevelProvider.level.queue_free()
	level_manager.load_level()
	main_menu.show()
	LevelProvider.save_file.save_game()

func set_resolution(resolution: Resolution) -> void:
	get_window().size = resolutions[resolution]
