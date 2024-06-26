class_name ReelProgress
extends Control

signal filled
signal timeout

@export var reel_bar: TextureProgressBar
@export var progress: TextureProgressBar
@export var player_bar: TextureProgressBar
@export var timeout_timer: Timer

@export var progress_increase := 0.5
@export var progress_decrease := 0.05

@export var min_player_speed := 50
@export var max_player_speed := 150

@export var max_reel_speed := 120
@export var min_reel_speed := 60

@export var min_reel_size := 50
@export var max_reel_size := 100

@onready var reel_speed := min_reel_speed
@onready var anim := $AnimationPlayer

var progress_value = 0.0
var _start = false
var time = 0.0

var is_action_pressed = false

func start(time_limit: float):
	progress_value = 0.0
	time = time_limit
	reel_bar.radial_initial_angle = rad_to_deg(-PI/2)
	player_bar.radial_initial_angle = 0.0
	_start = true
	show()
	timeout_timer.start(time_limit)
	anim.stop()
	
func stop():
	hide()
	_start = false
	timeout_timer.stop()
	anim.stop()

func _process(delta):
	if not _start: return
	
	if timeout_timer.time_left <= time / 2 and not anim.is_playing():
		anim.play("blink")
	
	progress.value = progress_value
	
	reel_bar.radial_initial_angle += reel_speed * delta

	var player_speed = 0
	if is_action_pressed:
		player_speed = max_player_speed
		
	player_bar.radial_initial_angle += player_speed * delta
	
	var start_angle = reel_bar.radial_initial_angle
	var end_angle = start_angle + reel_bar.value
	var player_angle = player_bar.radial_initial_angle
	
	var start = start_angle
	var end = end_angle if end_angle <= 360 else (end_angle - 360)
	
	if start < end:
		if player_angle >= start and player_angle <= end:
			_process_inside()
		else:
			_process_outside()
	else:
		if (player_angle >= start and player_angle < 360) or (player_angle <= end and player_angle >= 0):
			_process_inside()
		else:
			_process_outside()


func _on_reel_speed_change_timer_timeout():
	var speed_range = max_reel_speed - min_reel_speed
	var mid_reel_speed = min_reel_speed + speed_range / 2.0
	if reel_speed > mid_reel_speed:
		reel_speed = randi_range(min_reel_speed, mid_reel_speed)
	else:
		reel_speed = randi_range(mid_reel_speed, max_reel_speed)


func _on_reel_size_change_timer_timeout():
	var new_reel_size = float(randi_range(min_reel_size, max_reel_size))
	var tw = create_tween()
	tw.tween_property(reel_bar, "value", new_reel_size, 1.0)

func _process_inside():
	reel_bar.tint_progress = Color.BLUE
	progress_value = min(progress_value + progress_increase, progress.max_value)
	
	if progress_value >= progress.max_value:
		filled.emit()

func _process_outside():
	reel_bar.tint_progress = Color.WHITE
	progress_value = max(progress_value - progress_decrease, progress.min_value)


func _on_reel_timeout_timeout():
	timeout.emit()
