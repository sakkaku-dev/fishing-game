class_name FishCollection
extends Dialog

@export var container: Control
@export var item_scene: PackedScene

func _ready() -> void:
	super._ready()
	visibility_changed.connect(func():
		if visible:
			_update()
	)

func _update():
	var fish_chances = GameManager.get_catchable_fishes()
	
	for c in container.get_children():
		c.queue_free()
	
	for fish in fish_chances:
		var node = item_scene.instantiate()
		container.add_child(node)
		node.set_fish(fish[2], fish[1])
