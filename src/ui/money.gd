extends Label

func _ready() -> void:
	_update()
	GameManager.money_changed.connect(func(): _update())
	
func _update():
	text = "$%s" % GameManager.money
