extends Path3D
class_name BombToss

@onready var bomb: RigidBody3D = $PathFollow3D/Bomb
@onready var bomb_timer: Timer = $PathFollow3D/Bomb/Timer
@onready var bomb_label: Label3D = $PathFollow3D/Bomb/Blast/Node3D/Label3D

var triggered: bool = false

func _ready() -> void:
	var tween: Tween = create_tween()
	var explosion_sfx: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	explosion_sfx.set_stream(preload("res://assets/audio/sfx/bomb.wav"))
	explosion_sfx.connect("finished", explosion_sfx.queue_free)
	explosion_sfx.set_bus("SFX")
	LevelProvider.level.audio_players.add_child(explosion_sfx)
	tween.tween_callback(bomb_timer.start).set_delay(0.87)
	tween.tween_callback(_play_explosion_sfx.bind(explosion_sfx)).set_delay(3.1)

func _physics_process(_delta: float) -> void:
	var anchor: Node3D = bomb_label.get_parent()
	anchor.look_at(LevelProvider.level.camera.position)
	var time_left: float = bomb_timer.time_left + 0.5
	var timer_started: bool = not bomb_timer.is_stopped()
	if timer_started and time_left < 1:
		bomb_label.modulate = Color(1.0, 0.0, 0.0, bomb_label.modulate.a)
	elif timer_started and time_left < 2:
		bomb_label.modulate = Color(1.0, 0.45, 0.0, bomb_label.modulate.a)
	elif timer_started and time_left < 3:
		bomb_label.modulate = Color(1.0, 0.65, 0.0, bomb_label.modulate.a)
	if not timer_started and not triggered:
		bomb_label.text = "3"
	elif not timer_started and triggered:
		bomb_label.text = "0"
	else:
		bomb_label.text = "%d" % [time_left]

func _on_timer_timeout() -> void:
	triggered = true
	var tween: Tween = create_tween()
	tween.tween_callback(bomb._explode).set_delay(0.3)
	tween.tween_callback(queue_free).set_delay(0.2)

func _play_explosion_sfx(audio_player: AudioStreamPlayer3D) -> void:
	audio_player.global_position = bomb.global_position
	audio_player.play()
