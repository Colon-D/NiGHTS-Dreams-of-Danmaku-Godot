extends Node

# ♪ I just wiggled around ♪

@export var node_path: NodePath = ".."
@onready var node: Node2D = get_node(node_path)

@export var speed: float = 128.0
@export var amplitude: float = 64.0
@export var frequency: float = 64.0

var prev_position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	node.position.x += speed * delta
	node.position.y = sin(node.position.x / frequency) * amplitude
	# rotate the node to face the direction it's moving
	node.rotation = (node.position - prev_position).angle()

	prev_position = node.position
