extends Node2D

@export var fish_scene: PackedScene
@export var selected_panel: Control
@export var selected_label: Label
@export var selected_image: TextureRect
@export var sell_button: Button

var selected_fish = null:
	set(v):
		selected_fish = v
		
		if v:
			var data = GameManager.get_fish_data(v.fish)
			selected_label.text = "%s" % data["name"]
			selected_image.texture = GameManager.load_fish_icon(v.fish)
			sell_button.text = "Sell (%s)" % data["price"]
			
		selected_panel.visible = v != null
			
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		self.selected_fish = null

func _on_move_fishing_pressed():
	GameManager.go_to_fishing()


func _on_sell_pressed() -> void:
	if selected_fish == null: return
	GameManager.sell_fish(selected_fish.fish)
	selected_fish.queue_free()
	self.selected_fish = null
