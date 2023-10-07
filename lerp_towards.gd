extends Node

@export var node_path: NodePath = ".."
@onready var node: Node2D = get_node(node_path)

@export var to: Node2D
@export var time = 1.0
var from: Vector2
var from_scale: Vector2
var timer: float

func set_target(target: Node2D) -> void:
	from = node.global_position
	from_scale = node.global_scale
	to = target

func _ready():
	from = node.global_position
	from_scale = node.global_scale

# https://easings.net/#easeInOutSine
func ease_in_out_sine(x: float) -> float:
	return -(cos(PI * x) - 1.0) / 2.0

func _physics_process(delta: float) -> void:
	if not to:
		return

	timer += delta
	if timer >= time:
		node.get_parent().remove_child(node)
		to.add_child(node)
		node.position = Vector2.ZERO
		node.scale = Vector2.ONE
		queue_free()
		return
	node.global_position = lerp(from, to.global_position, ease_in_out_sine(timer / time))
	node.global_scale = lerp(from_scale, to.global_scale, ease_in_out_sine(timer / time))
