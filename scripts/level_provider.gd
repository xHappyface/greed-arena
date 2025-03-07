extends Node

var save_file: SaveFile
var level: Level

var last_earned: int = -1
var last_time: int = -1

const SPEED_RANKS: int = 5
const TIME_RANKS: int = 5
const MAGNET_RANKS: int = 3
const MONEY_BUNDLE_RANKS: int = 3
const MONEY_BAG_RANKS: int = 3

enum Rank {
	SPEED,
	TIME,
	MAGNET,
	MONEY_BUNDLE,
	MONEY_BAG,
}

var ranks: Dictionary = {
	Rank.SPEED: 0,
	Rank.TIME: 0,
	Rank.MAGNET: 0,
	Rank.MONEY_BUNDLE: 0,
	Rank.MONEY_BAG: 0,
}

func slow_time() -> void:
	var tween: Tween = create_tween()
	var audio_tween: Tween = create_tween()
	Engine.time_scale = 0.5
	LevelProvider.level.player.speed = Player.get_real_speed() * 4.0
	LevelProvider.level.player.rotation_multiplier = 0.25
	audio_tween.tween_property(AudioServer, "playback_speed_scale", 0.5, 0.3)
	audio_tween.tween_property(AudioServer, "playback_speed_scale", 1.0, 0.3).set_delay(2.4)
	tween.tween_callback(Engine.set.bind("time_scale", 1.0)).set_delay(3.0)
	tween.tween_callback(LevelProvider.level.player.set.bind("speed", Player.get_real_speed()))
	tween.tween_callback(LevelProvider.level.player.set.bind("rotation_multiplier", 1.0))

func update_game_timer() -> void:
	level.game_timer.stop()
	level.game_timer.wait_time = level.BASE_GAME_TIME + (ranks[Rank.TIME] * level.TIME_GROWTH_RATE)
	level.game_timer.start()
