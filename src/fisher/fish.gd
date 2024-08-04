class_name Fish
extends CharacterBody2D

signal clicked()

@export var max_move_dist := 200
@export var move_speed := 15

@export var fish := 1

@onready var idle_timer: RandomTimer = $IdleTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var navigation_agent_2d: NavigationMove2D = $NavigationAgent2D
@onready var control: Control = $Control

var selected = false

func _ready() -> void:
	sprite_2d.texture = GameManager.load_fish_icon(fish)
	idle_timer.timeout.connect(func(): _update_move_target())
	
	sprite_2d.material = sprite_2d.material.duplicate()
	control.mouse_entered.connect(func():
		if not GameManager.is_placing_item:
			set_sprite_outline(true)
	)
	control.mouse_exited.connect(func():
		if not selected:
			set_sprite_outline(false)
	)
	control.gui_input.connect(func(ev: InputEvent):
		if ev.is_action_pressed("click") and not selected and not GameManager.is_placing_item:
			clicked.emit()
	)
	set_sprite_outline(false)
	
	await get_tree().create_timer(.1
	).timeout
	global_position = _new_move_target()
	_update_move_target()

func set_sprite_outline(enabled = false):
	var mat = sprite_2d.material as ShaderMaterial
	mat.set_shader_parameter("enable", enabled)
	z_index = 5 if enabled else 0

func _flip_for_movement():
	if velocity.length() <= 0.01: return
	
	var flipped = sign(velocity.x) > 0
	sprite_2d.flip_h = flipped
	sprite_2d.rotation_degrees = 45 if flipped else -45

func _update_move_target():
	navigation_agent_2d.set_target(_new_move_target())

func _new_move_target():
	var target = NavigationServer2D.map_get_random_point(get_world_2d().navigation_map, 1, false)
	var dir = (target - global_position).limit_length(max_move_dist)
	return global_position + dir

func _physics_process(delta: float) -> void:
	navigation_agent_2d.process(delta)
	_flip_for_movement()
	
