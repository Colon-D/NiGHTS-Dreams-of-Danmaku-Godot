extends Node2D

@export var emit: PackedScene;

func fire():
	var child = emit.instantiate()
	add_child(child)
	child.propagate_call("teleport")
