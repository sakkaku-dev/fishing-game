class_name WaterSpring
extends Node2D

@onready var target_height := position.y
@onready var height := position.y

var velocity := 0.0
var force := 0.0

func update(stiffness: float, dampening: float):
	height = position.y
	
	var height_offset = height - target_height
	var loss = dampening * velocity
	
	# hooke's law: F = -K * x
	force = -stiffness * height_offset - loss
	
	velocity += force
	position.y += velocity
