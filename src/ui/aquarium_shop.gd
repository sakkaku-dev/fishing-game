extends Control

@export var items: Array[AquariumResource] = []
@export var scene: PackedScene

func _ready() -> void:
	for item in items:
		var node = scene.instantiate()
		node.res = item
		node.buy_item.connect(func(x): GameManager.buy_item(x))
		add_child(node)
