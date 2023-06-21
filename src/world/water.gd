extends Node2D

@export var water_spring_scene: PackedScene
@export var polygon: Polygon2D

@export var stiffness := 0.015
@export var dampening := 0.03
@export var spread := 0.002
@export var spread_passes := 200

@export var spring_count := 20
@export var spring_offset := 20
@export var height := 100

@onready var target_height := position.y

var springs = []
var left_deltas = []
var right_deltas = []
var current_spread_passes = 0

func _ready():
	for i in range(spring_count):
		var x = i * spring_offset
		var spring = water_spring_scene.instantiate() as WaterSpring
		spring.position = Vector2(x, 0)
		springs.append(spring)
		add_child(spring)
		
	splash(spring_count/2, 5)

func _physics_process(delta):
	for child in springs:
		child.update(stiffness, dampening)
	
	# TODO: improve, the higher the spread, the stronger the splash -> it's weird
	if current_spread_passes < spread_passes:
		for i in range(springs.size()):
			var spring = springs[i]
			if i > 0:
				var prev_spring = springs[i - 1]
				left_deltas[i] = spread * (spring.height - prev_spring.height)
				prev_spring.velocity += left_deltas[i]
			if i < springs.size() - 1:
				var next_spring = springs[i + 1]
				right_deltas[i] = spread * (spring.height - next_spring.height)
				next_spring.velocity += right_deltas[i]
		current_spread_passes += 1
	
	_update_polygon()

func _update_polygon():
	var pos = []
	for spring in springs:
		pos.append(spring.position)
	
	pos.append(Vector2(pos[pos.size() - 1].x, height))
	pos.append(Vector2(0, height))
	polygon.polygon = pos

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed
	
	left_deltas = []
	right_deltas = []
	current_spread_passes = 0
	for i in range(get_child_count()):
		left_deltas.append(0)
		right_deltas.append(0)
