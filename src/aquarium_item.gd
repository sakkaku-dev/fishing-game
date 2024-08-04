extends TextureButton

@export var res: AquariumResource

var count := 0

func _ready() -> void:
	texture_normal = res.sprite
	$Label.text = "%sx" % count
