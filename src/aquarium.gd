extends Node2D

@export var fish_scene: PackedScene
@export var selected_panel: Control
@export var selected_label: Label
@export var selected_image: TextureRect
@export var sell_button: Button

@export var aquarium_item_scene: PackedScene

@onready var placeholder: Sprite2D = $Placeholder
@onready var aquarium_items: PanelContainer = $CanvasLayer/Control/AquariumItems

var placing_item = null:
	set(v):
		placing_item = v
		GameManager.is_placing_item = v != null
		
		if v:
			placeholder.texture = v.sprite
			placeholder.show()
		else:
			placeholder.hide()
		
var selected_fish = null:
	set(v):
		selected_fish = v
		
		if v:
			var data = GameManager.get_fish_data(v.fish)
			selected_label.text = "%s" % data["name"]
			selected_image.texture = GameManager.load_fish_icon(v.fish)
			sell_button.text = "Sell (%s)" % data["price"]
			
		selected_panel.visible = v != null
		if selected_panel.visible:
			aquarium_items.hide()
			
		for c in get_children():
			if not c is Fish: continue
			c.selected = c == v
			c.set_sprite_outline(c.selected)

func _ready():
	self.selected_fish = null
	for fish in GameManager.aquarium:
		var node = fish_scene.instantiate()
		node.fish = fish
		node.clicked.connect(func(): self.selected_fish = node)
		add_child(node)
	
	placeholder.hide()
	
	GameManager.used_item.connect(func(i):
		var item = aquarium_item_scene.instantiate()
		item.res = i
		item.global_position = get_global_mouse_position()
		add_child(item)
	)
	aquarium_items.visibility_changed.connect(func():
		if aquarium_items.visible:
			self.selected_fish = null
	)

func _process(delta: float) -> void:
	if placeholder.visible:
		placeholder.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and placing_item != null:
		if GameManager.use_item(placing_item) == 0:
			self.placing_item = null
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if selected_fish:
			self.selected_fish = null
	elif event.is_action_pressed("ui_cancel"):
		if selected_fish:
			self.selected_fish = null
		if placeholder.visible:
			self.placing_item = null


func _on_move_fishing_pressed():
	GameManager.go_to_fishing()


func _on_sell_pressed() -> void:
	if selected_fish == null: return
	GameManager.sell_fish(selected_fish.fish)
	selected_fish.queue_free()
	self.selected_fish = null


func _on_aquarium_items_place_item(item: AquariumResource) -> void:
	self.placing_item = item
