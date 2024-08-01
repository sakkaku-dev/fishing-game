extends CharacterBody2D

@export var max_move_dist := 100
@export var move_speed := 10

@export var fish := 1

@onready var idle_timer: RandomTimer = $IdleTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

var move_target = null

func _ready() -> void:
	sprite_2d.texture = GameManager.load_fish_icon(fish)
	idle_timer.timeout.connect(func(): move_target = _new_move_target())
	global_position = _new_move_target()

func _flip_for_movement():
	if velocity.length() <= 0.01: return
	
	var flipped = sign(velocity.x) > 0
	sprite_2d.flip_h = flipped
	sprite_2d.rotation_degrees = 45 if flipped else -45

func _new_move_target():
	var target = NavigationServer2D.map_get_random_point(get_world_2d().navigation_map, 1, false)
	var dir = (target - global_position).limit_length(max_move_dist)
	return global_position + dir

func _physics_process(delta: float) -> void:
	if move_target == null:
		return
	
	var dir = global_position.direction_to(move_target)
	velocity = dir * move_speed
	
	_flip_for_movement()
	
	move_and_slide()
	
	if global_position.distance_to(move_target) < 5:
		move_target = null
		idle_timer.start()
