extends Node2D

enum State {
	IDLE,
	MOVING,
	DRILL_DASHING,
}
var state := State.IDLE
var vel := Vector2.ZERO

@export var idle_rot_vel := 90
@export var idle_accel := 350
@export var idle_grav := 12
@export var moving_rot_vel := 400
@export var moving_spd := 350
@export var moving_accel := 350
@export var drill_dash_rot_vel := 100
@export var drill_dash_spd := 700
@export var drill_dash_accel := 700

@export var drill_dash_animation_player: AnimationPlayer

func _ready():
	pass

func _process(_delta: float):
	pass

func _physics_process(delta: float):
	# get state depending on input
	var input := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)

	if Input.is_action_pressed("drill_dash"):
		state = State.DRILL_DASHING
	else:
		state = State.IDLE if input == Vector2.ZERO else State.MOVING

	# change rotation/speed depending on state and input
	var target_rot: Vector2
	var max_rot: float

	var target_spd: float
	var accel: float
	var vel_dir: Vector2

	match state:
		State.IDLE:
			target_rot = Vector2.UP
			max_rot = deg_to_rad(idle_rot_vel)

			accel = idle_accel
			target_spd = 0

			vel_dir = vel.normalized()
		State.MOVING:
			target_rot = input
			max_rot = deg_to_rad(moving_rot_vel)

			accel = moving_accel
			target_spd = moving_spd * input.length()

			vel_dir = Vector2.from_angle(rotation)
		State.DRILL_DASHING:
			target_rot = input
			max_rot = deg_to_rad(drill_dash_rot_vel)

			accel = drill_dash_accel
			target_spd = drill_dash_spd

			vel_dir = Vector2.from_angle(rotation)

			# also play drill dash animation if drill dashing
			drill_dash_animation_player.play("drill_dash")

	# rotate towards target angle
	var rot_by = max_rot * delta
	var delta_rot := Vector2.from_angle(rotation).angle_to(target_rot)
	rotation += clamp(delta_rot, -rot_by, rot_by)

	# change velocity towards target speed and velocity direction
	var curr_spd := vel.length()
	var spd := move_toward(curr_spd, target_spd, accel * delta)
	vel = vel_dir * spd

	# apply velocity
	position += vel * delta

	# fall due to gravity when idle
	if state == State.IDLE:
		position.y += idle_grav * delta
