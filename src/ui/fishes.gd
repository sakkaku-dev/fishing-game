class_name Fishes
extends Control

@export var container: Control
@export var item_scene: PackedScene

func _ready() -> void:
	hide()
	
	for c in container.get_children():
		c.queue_free()
	
	for fish in GameManager.fish_data:
		var node = item_scene.instantiate()
		node.set_fish(fish)
		container.add_child(node)
