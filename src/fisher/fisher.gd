extends Node2D

signal caught_fish()
signal lost_fish()

@export var anim: AnimationPlayer
@export var reel: ReelProgress

var fishing = true

func _ready():
	reel.stop()


func hooked_fish():
	anim.play("bite")
	reel.start(10.0)
	
	
func _on_reel_progress_filled():
	caught_fish.emit()
	reel.stop()
	anim.play("fish_in")
	fishing = false

func _on_reel_progress_timeout():
	lost_fish.emit()
	reel.stop()
	anim.play("fish_leave")
	fishing = true

func _unhandled_input(event):
	if not fishing and not anim.is_playing() and event.is_action_pressed("action"):
		start_fishing()

func start_fishing():
	fishing = true
	anim.play("throw")

