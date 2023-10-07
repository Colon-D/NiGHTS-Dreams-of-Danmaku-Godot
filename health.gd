extends Node2D

@export var health := 5
@export var invulnerable_time := 1.0
var curr_invulnerable_time := 1.0

signal death
signal hurt(health: int)

func _ready() -> void:
	# assert that Ideya in UI is same as health
	var nodes = get_tree().get_nodes_in_group("ideya ui")
	if nodes.is_empty():
		printerr("Warning: no ideya ui found, can't assert health synced.")
		return
	var ideya_ui = nodes[0]
	assert(ideya_ui.get_child_count() == health, "Ideya UI and health are not synced.")

func damage() -> void:
	if curr_invulnerable_time > 0:
		return
	curr_invulnerable_time = invulnerable_time
	health -= 1
	hurt.emit(health)
	if health <= 0:
		death.emit()

func _physics_process(delta: float) -> void:
	curr_invulnerable_time -= delta

	if curr_invulnerable_time > 0:
		modulate.a = 1.0 if fmod(curr_invulnerable_time, 0.2) < 0.1 else 0.0
	else:
		modulate.a = 1.0
