extends Path3D
class_name Bomb

@onready var bomb: RigidBody3D = $PathFollow3D/Bomb
@onready var bomb_timer: Timer = $PathFollow3D/Bomb/Timer
@onready var bomb_label: Label3D = $PathFollow3D/Bomb/Label3D
@onready var blast: Area3D = $PathFollow3D/Bomb/Blast

var level: Level = null

var triggered: bool = false

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_callback(bomb_timer.start).set_delay(1.2)

func _physics_process(delta: float) -> void:
	var timer_started: bool = not bomb_timer.is_stopped()
	if timer_started and bomb_timer.time_left < 1:
		bomb_label.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif timer_started and bomb_timer.time_left < 2:
		bomb_label.modulate = Color(1.0, 0.45, 0.0, 1.0)
	elif timer_started and bomb_timer.time_left < 3:
		bomb_label.modulate = Color(1.0, 0.65, 0.0, 1.0)
	if not timer_started and not triggered:
		bomb_label.text = "3"
	elif not timer_started and triggered:
		bomb_label.text = "0"
	else:
		bomb_label.text = "%d" % [bomb_timer.time_left]

func _on_timer_timeout() -> void:
	triggered = true
	var tween: Tween = create_tween()
	tween.tween_callback(_explode).set_delay(0.3)

func _explode() -> void:
	if level:
		var overlapping_bodies: Array[Node3D] = blast.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is Player:
				level.level_manager.get_parent().stop_game()
