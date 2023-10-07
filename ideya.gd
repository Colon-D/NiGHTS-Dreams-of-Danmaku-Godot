extends Node2D

@export var lerp_towards: Node
@export var projectile_movement: Node
var prev_pos: Vector2
var velocity: Vector2

func lose() -> void:
	var root = get_tree().root
	var pos = global_position
	var new_scale = global_scale
	get_parent().remove_child(self)
	root.add_child(self)
	global_position = pos
	global_scale = new_scale
	if lerp_towards != null:
		lerp_towards.queue_free()
	projectile_movement.process_mode = PROCESS_MODE_INHERIT
	projectile_movement.spd = velocity.length()
	rotation = velocity.angle()

func _physics_process(delta: float) -> void:
	velocity = (global_position - prev_pos) / delta
	prev_pos = global_position
