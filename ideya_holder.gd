extends Node2D

@export var ideya: PackedScene
var requested_ideya: Node2D

@export var hitbox: CollisionShape2D
@export var ideya_texture: Texture2D

func _ready() -> void:
	request_ideya.call_deferred()
	scale = Vector2.ONE * 2.0 * hitbox.shape.radius / ideya_texture.get_size().x

func on_hurt(health: int) -> void:
	if health > 0:
		request_ideya()
	else:
		# lose last ideya on death
		requested_ideya.propagate_call("lose")

func request_ideya() -> void:
	# if there is already an ideya, lose it
	if requested_ideya != null:
		requested_ideya.propagate_call("lose")

	var nodes = get_tree().get_nodes_in_group("ideya ui")
	if nodes.is_empty():
		printerr("Warning: no ideya ui found, can't request ideya.")
		return
	var ideya_ui = nodes[0]

	if ideya_ui.get_child_count() == 0:
		printerr("Warning: ideya ui has no ideya, can't request ideya.")
		return

	# get position and modulate of the ideya
	var new_ideya = ideya_ui.get_child(-1)
	var trans = get_viewport().get_canvas_transform().affine_inverse()
	var pos = trans * (new_ideya.global_position + new_ideya.size / 2.0)
	var new_scale = Vector2.ONE * trans.get_scale().y
	var mod = new_ideya.modulate
	new_ideya.queue_free()

	# spawn the ideya
	requested_ideya = ideya.instantiate()
	get_tree().root.add_child(requested_ideya)
	requested_ideya.global_position = pos
	requested_ideya.global_scale = new_scale
	requested_ideya.modulate = mod
	requested_ideya.propagate_call("teleport")
	requested_ideya.propagate_call("set_target", [self])


func hurt(health):
	pass # Replace with function body.
