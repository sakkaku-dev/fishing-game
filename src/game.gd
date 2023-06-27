extends Node2D

const ROPE = preload("res://src/fisher/rope.tscn")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		var hook = ROPE.instantiate()
		hook.global_position = pos
		add_child(hook)
