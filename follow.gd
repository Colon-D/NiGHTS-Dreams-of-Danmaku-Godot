extends Node2D

# ♪ From a good safe distance ♪

@export var distance = 128
@export var follow: Node2D

func _physics_process(delta: float) -> void:
	var direction = (follow.position - position).normalized()
	position = follow.position - direction * scale.x * distance
	rotation = direction.angle()
