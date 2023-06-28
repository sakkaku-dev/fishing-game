extends CharacterBody2D

enum {
	FALL,
	FLOAT_UP,
	FLOAT_SURFACE
}

@export var max_floating_speed := 100
@export var floating_accel := 500

@onready var gravity := Vector2.DOWN * 10
@onready var sprite := $Sprite2D

var state = FALL
var float_pos_y = 0
var time = 0

func stop_floating():
	state = FALL


func start_floating():
	state = FLOAT_UP
	float_pos_y = global_position.y


func _physics_process(delta):
	match state:
		FALL: velocity += gravity
		FLOAT_UP:
			var dist = abs(float_pos_y - global_position.y)
			var near_surface = dist < 10
			
			if near_surface and velocity.length() < 5:
				state = FLOAT_SURFACE
				time = 0
				return
			
			var speed = max_floating_speed/(5/dist)
			speed = min(speed, max_floating_speed)
			velocity = velocity.move_toward(Vector2.UP * speed, delta * floating_accel)
			
		FLOAT_SURFACE:
			velocity = Vector2.ZERO
			time += delta
			var force = 3 * sin(time)
			sprite.position = Vector2.UP * force

	move_and_slide()
