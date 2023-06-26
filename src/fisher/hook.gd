extends CharacterBody2D

@onready var gravity := Vector2.DOWN * 10

func _physics_process(delta):
	velocity += gravity
	move_and_slide()
