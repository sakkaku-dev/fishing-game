extends PanelContainer

signal place_item(item)

@export var toggle_button: BaseButton
@export var container: Control
@export var scene: PackedScene

func _ready() -> void:
	_update()
	
	GameManager.bought_item.connect(func(i):
		if i is AquariumResource:
			_update()
	)
	GameManager.used_item.connect(func(_i): _update())
	
	hide()
	toggle_button.pressed.connect(func():
		if visible:
			hide()
		else:
			show()
	)
	
func _update():
	for c in container.get_children():
		c.queue_free()
	
	var items = {}
	for item in GameManager.aquarium_items:
		var x = GameManager.get_aquarium_item(item)
		if not x.type in items:
			items[x.type] = []
		items[x.type].append(x)
	
	for item_type in items:
		if items[item_type].is_empty(): continue
		
		var node = scene.instantiate() as TextureButton
		node.res = items[item_type][0]
		node.count = items[item_type].size()
		node.pressed.connect(func(): place_item.emit(items[item_type][0]))
		container.add_child(node)
