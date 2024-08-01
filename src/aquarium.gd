extends Node2D

@export var fish_scene: PackedScene

func _ready():
	for fish in GameManager.aquarium:
		var node = fish_scene.instantiate()
		node.fish = fish
		add_child(node)


func _on_move_fishing_pressed():
	GameManager.go_to_fishing()
