extends Node2D

const SECONDS_IN_DAY = 86400

@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("run")
	animation_player.pause()

func _process(delta):
	GameManager.day_time += delta
	
	var p = remap(GameManager.day_time, 0, GameManager.max_day_time, 0, animation_player.current_animation_length)
	animation_player.seek(p)
	
