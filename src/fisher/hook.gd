extends RigidBody2D

@export var max_floating_speed := 80
@export var floating_accel := 100

#@onready var gravity := Vector2.DOWN * 10
#@onready var water_float := $WaterFloat

var spring = null

#func _physics_process(delta):
#	if not spring:
#		velocity += gravity
#	else:
#		var dist = global_position.distance_to(spring.global_position)
#		var near_surface = dist < 5
#		var speed = floating_speed/(5/dist) if near_surface else floating_speed
#
#		var dir = global_position.direction_to(spring.global_position)
#		velocity = velocity.move_toward(dir * speed, delta * floating_accel)
#
#	move_and_slide()

func _on_water_float_area_entered(area):
	if not spring:
		spring = area as WaterSpring
		gravity_scale = 0.0
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	if spring:
		var dist = global_position.distance_to(spring.global_position)
		var near_surface = dist < 5
		var speed = max_floating_speed/(5/dist)
		speed = min(speed, max_floating_speed)
		
		var dir = global_position.direction_to(spring.global_position)
		var v = state.linear_velocity
		state.linear_velocity = v.move_toward(dir * speed, floating_accel)
#		global_position = spring.global_position
