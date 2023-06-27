extends CharacterBody2D

@export var floating_speed := 50
@export var floating_accel := 2000

@onready var gravity := Vector2.DOWN * 10
@onready var water_float := $WaterFloat

var spring = null

func _physics_process(delta):
	if not spring:
		velocity += gravity
	else:
		var dist = global_position.distance_to(spring.global_position)
		var near_surface = dist < 5
		var speed = floating_speed/(5/dist) if near_surface else floating_speed
		
		var dir = global_position.direction_to(spring.global_position)
		velocity = velocity.move_toward(dir * speed, delta * floating_accel)

	move_and_slide()

func _on_water_float_area_entered(area):
	if not spring:
		spring = area as WaterSpring
	
