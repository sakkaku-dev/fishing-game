class_name WaterSpring
extends Area2D

@export var collision: CollisionShape2D

@onready var target_height := position.y

var velocity := 0.0
var mass := 1.0

func set_collision_width(width):
	var shape = collision.shape as RectangleShape2D
	shape.size.x = width
