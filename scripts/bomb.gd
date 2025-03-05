extends RigidBody3D
class_name Bomb

@export var shock_curve: Curve

@onready var shockwave: Area3D = $Shockwave
@onready var blast: Area3D = $Blast

var is_y_snapped: bool = false

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_callback(set_collision_layer_value.bind(6, true)).set_delay(1.0)
	tween.tween_callback(set_collision_mask_value.bind(6, true))
	tween.tween_callback(set.bind("is_y_snapped", true))

func _physics_process(_delta: float) -> void:
	if is_y_snapped:
		global_position.y = 0.01

func _explode() -> void:
	var shockwave_bodies: Array[Node3D] = shockwave.get_overlapping_bodies()
	var blast_bodies: Array[Node3D] = blast.get_overlapping_bodies()
	for body in blast_bodies:
		if body is Player:
			body.take_hit()
	for body in shockwave_bodies:
		if body == self:
			continue
		elif body is RigidBody3D:
			print("@@@@@@@@@@@@@@@@@@@@@@@")
			var shockwave_radius: float = shockwave.get_child(0).shape.radius
			var distance_away: float = \
			  (shockwave_radius - global_position.distance_to(body.global_position)) / shockwave_radius
			body.apply_impulse((body.global_position - global_position).normalized() * 250.0 * \
			  shock_curve.sample(distance_away))
