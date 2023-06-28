# https://www.youtube.com/watch?v=RXIRkou021U
# https://gamedev.stackexchange.com/questions/44547/how-do-i-create-2d-water-with-dynamic-waves

extends Node2D

#@export var water_spring_scene: PackedScene
#@export var polygon: Polygon2D
#@export var border: SmoothPath

#@export_category("Water Waves")
#@export var wave_max_height := 3
#
#@export_category("Water Movement")
#@export var spread := 0.005
#@export var stiffness := 0.005
#@export var dampening := 0.98
#
#@export_category("Water Springs / Size")
#@export var spring_count := 20
#@export var spring_offset := 20
#@export var height := 100

var springs = []
var inside_water = []
var time = 0

#func _ready():
#	for i in range(spring_count):
#		var x = i * spring_offset
#		var spring = water_spring_scene.instantiate() as WaterSpring
#		spring.position = Vector2(x, 0)
#		spring.body_entered.connect(func(body): splash(i, body))
#		springs.append(spring)
#		add_child(spring)
#
#		spring.position.y = spring.target_height + _wave(i)
#
#		if i == 0: # springs are sharing the collision shape
#			spring.set_collision_width(spring_offset)
#
#func _wave(x):
#	return sin(1.2 * time + x) * wave_max_height
#
#func _physics_process(delta):
#	time += delta
#
#	for _x in range(5):
#		for i in range(springs.size()):
#			var spring = springs[i] as WaterSpring
#			var forceFromLeft = 0
#			var forceFromRight = 0
#
#			if i > 0:
#				var prev_spring = springs[i - 1]
#				var d = prev_spring.position.y - spring.position.y
#				forceFromLeft = spread * d
#			if i < springs.size() - 1:
#				var next_spring = springs[i + 1]
#				var d = next_spring.position.y - spring.position.y
#				forceFromRight = spread * d
#
#			var target = spring.target_height + _wave(i)
#			var height_offset = target - spring.position.y
#			var forceToBaseline = stiffness * height_offset
#
#			var force = forceFromLeft + forceFromRight + forceToBaseline
#			var accel = force / spring.mass
#			spring.velocity = dampening * spring.velocity + accel
#
#			spring.position.y += spring.velocity
#
#	_update_border()
#	_update_polygon()
#
#func _update_polygon():
#	var pos = border.curve.get_baked_points()
#	pos.append(Vector2(pos[pos.size() - 1].x, height))
#	pos.append(Vector2(0, height))
#	polygon.polygon = pos
#
#func _update_border():
#	var curve = Curve2D.new()
#
#	for pos in _spring_positions():
#		curve.add_point(pos)
#
#	border.curve = curve
#	border.smooth(true)
#	border.queue_redraw()
#
#func _spring_positions():
#	var result = []
#	for spring in springs:
#		result.append(spring.position)
#	return result
#
#func splash(index, body: Node2D):
#	if body in inside_water:
#		return
#
#	if index < 0 or index >= springs.size():
#		return
#
#	var spring = springs[index]
#	inside_water.append(body)
#	spring.velocity = 5


func _on_body_entered(body):
	body.start_floating()


func _on_body_exited(body):
	body.stop_floating()
