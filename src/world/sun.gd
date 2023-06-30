extends Node2D

@export var start := -1000
@export var end := 1000

@onready var sun := $Sun
@onready var bg := $BG

const SECONDS_IN_DAY = 86400

func _physics_process(delta):
	sun.move_local_y(0.1)
	
	if sun.global_position.y >= end:
		sun.global_position.y = start
