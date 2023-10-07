extends Node

@export var node_path: NodePath = ".."
@onready var node: Node2D = get_node(node_path)

@export var spd := 0.0
@export var acc := 0.0
@export var ang_vel := 0.0
@export var ang_acc := 0.0
@export var gravity := 0.0
@export var offscreen := 96.0
@export var timer := INF

var gameplay: Node2D

func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("gameplay")
	if nodes.is_empty():
		if timer == INF:
			printerr("Warning: no gameplay node found, and timer is infinite. This will never be deleted.")
	else:
		gameplay = nodes[0]

func _physics_process(delta: float) -> void:
	# add acceleration and angular acceleration
	spd += acc * delta
	ang_vel += ang_acc * delta # ang_vel in degrees, so do not convert ang_acc

	# add gravity
	var vel = Vector2.from_angle(node.rotation) * spd
	vel.y += gravity * delta
	spd = vel.length()
	if spd > 0.0:
		node.rotation = vel.angle()

	# apply velocity and angular velocity
	node.position += Vector2.from_angle(node.rotation) * spd * delta
	node.rotation += deg_to_rad(ang_vel) * delta

	if gameplay:
		if not gameplay.danmaku_area.grow(offscreen).has_point(node.global_position):
			node.queue_free()

	timer -= delta
	if timer <= 0.0:
		node.queue_free()
