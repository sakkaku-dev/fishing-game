extends Control

@export var btn: TextureButton
@export var chance_label: Label
@export var panel: PanelContainer

var fish_id: int

func _ready() -> void:
	GameManager.caught_fish.connect(func(id):
		if id == fish_id:
			print("Caught %s, unlocking %s" % [id, fish_id])
			_update_unlocked()
	)
	
	btn.material = btn.material.duplicate()

func set_fish(fish: Dictionary, chance: float):
	fish_id = fish["id"]
	btn.texture_normal = GameManager.load_fish_icon(fish_id)
	btn.tooltip_text = fish["name"]
	panel.self_modulate = GameManager.get_rarity_color(fish)
	
	chance_label.text = "%.2f%%" % [chance * 100]
	_update_unlocked()

func _update_unlocked():
	_set_fish_unlocked(GameManager.has_unlocked_fish(fish_id))

func _set_fish_unlocked(unlocked: bool):
	var mat = btn.material as ShaderMaterial
	mat.set_shader_parameter("enabled", not unlocked)
	btn.disabled = not unlocked
