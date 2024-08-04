class_name Dialog
extends PanelContainer

@export var open_button: BaseButton
@export var close_button: BaseButton

func _ready() -> void:
	hide()
	open_button.pressed.connect(func():
		if not visible:
			show()
		else:
			hide()
		
		get_viewport().gui_release_focus()
	)
	close_button.pressed.connect(func(): hide())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()
		get_viewport().set_input_as_handled()
