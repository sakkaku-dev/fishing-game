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
	var data = GameManager.get_fish_data(fish)
	
	fish_icon.texture = GameManager.load_fish_icon(fish)
	name_label.text = "%s" % data["name"]
	
	var mat = shine.material as ShaderMaterial
	var grad_tex = mat.get_shader_parameter("color_gradient") as GradientTexture1D
	var grad = grad_tex.gradient
	var color = GameManager.get_rarity_color(data)
	var end_color = color.darkened(0.5)
	
	grad.set_color(0, color)
	grad.set_color(1, end_color)
	
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

func _gui_input(event: InputEvent) -> void:
	if modulate == Color.WHITE and event.is_action_pressed("action"):
		stop()
