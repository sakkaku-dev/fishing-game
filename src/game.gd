extends Node2D

const ROPE = preload("res://src/fisher/hook.tscn")

@onready var player := $Fisher

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		var hook = ROPE.instantiate()
		hook.global_position = pos
		add_child(hook)


func _on_hooked_timer_timeout():
	player.hooked_fish()
