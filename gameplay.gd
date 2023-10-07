@tool
extends Node2D

@export var danmaku_area: Rect2:
	set(new_danmaku_area):
		danmaku_area = new_danmaku_area
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(danmaku_area, Color.RED, false, 2.0)
