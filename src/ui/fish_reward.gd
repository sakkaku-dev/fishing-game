extends Control

@onready var anim = $AnimationPlayer

func _ready():
	modulate = Color.TRANSPARENT

func start():
	anim.play("show")
	
func stop():
	anim.play_backwards("show")

func _unhandled_input(event):
	if modulate == Color.WHITE and event.is_action_pressed("action"):
		get_viewport().set_input_as_handled()
		stop()
