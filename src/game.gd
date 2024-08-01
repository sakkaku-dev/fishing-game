extends Node2D

const ROPE = preload("res://src/fisher/hook.tscn")

@export var fishes: Fishes

@onready var player := $Fisher
@onready var fish_reward := $CanvasLayer/FishReward

func _ready():
	GameManager.caught_fish.connect(func(id): fish_reward.start(id))

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		var hook = ROPE.instantiate()
		hook.global_position = pos
		add_child(hook)


func _on_hooked_timer_timeout():
	player.hooked_fish()


func _on_fisher_caught_fish():
	GameManager.add_fish()


func _on_fisher_lost_fish():
	pass # Replace with function body.


func _on_move_aquarium_pressed():
	GameManager.go_to_aquarium()


func _on_fishes_pressed() -> void:
	fishes.visible = not fishes.visible
	get_viewport().gui_release_focus()
