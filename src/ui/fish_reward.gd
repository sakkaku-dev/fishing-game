class_name FishReward
extends Control

@export var fish_icon: TextureRect
@export var name_label: Label
@export var first_catch_label: Label
@export var shine: Control

@onready var anim = $AnimationPlayer

func _ready():
	hide()
	modulate = Color.TRANSPARENT
	first_catch_label.hide()
	shine.hide()

func start(fish: int, first_unlock: bool):
	fish_icon.texture = GameManager.load_fish_icon(fish)
	name_label.text = "%s" % GameManager.get_fish_data(fish)["name"]
	
	if first_unlock:
		first_catch_label.show()
		shine.show()
	
	anim.play("show")
	
func stop():
	anim.play("hide")

func _unhandled_input(event):
	if modulate == Color.WHITE and event.is_action_pressed("action"):
		get_viewport().set_input_as_handled()
		stop()
