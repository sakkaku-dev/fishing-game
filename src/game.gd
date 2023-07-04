extends Node2D

const ROPE = preload("res://src/fisher/hook.tscn")

@onready var player := $Fisher
@onready var fish_reward := $CanvasLayer/FishReward

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		var hook = ROPE.instantiate()
		hook.global_position = pos
		add_child(hook)


func _on_hooked_timer_timeout():
	player.hooked_fish()


func _on_fisher_caught_fish():
	fish_reward.start()


func _on_fisher_lost_fish():
	pass # Replace with function body.
