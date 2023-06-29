extends Node2D

@export var start := -1000
@export var end := 1000

@onready var bg := $BG

const SECONDS_IN_DAY = 86400

func _physics_process(delta):
	move_local_y(0.5)
	
	if global_position.y >= end:
		global_position.y = start
