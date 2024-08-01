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
	fishing = false
	reel.stop()
	anim.play("fish_in")
	await anim.animation_finished
	caught_fish.emit()

func _on_reel_progress_timeout():
	fishing = true
	lost_fish.emit()
	reel.stop()
	anim.play("fish_leave")

func _unhandled_input(event):
	if not fishing and not anim.is_playing() and event.is_action_pressed("action"):
		start_fishing()

func _process(delta):
	reel.is_action_pressed = Input.is_action_pressed("action")

func start_fishing():
	fishing = true
	anim.play("throw")
