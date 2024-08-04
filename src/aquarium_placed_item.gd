extends Sprite2D

@export var res: AquariumResource

func _ready() -> void:
	texture = res.sprite
