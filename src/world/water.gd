# https://www.youtube.com/watch?v=RXIRkou021U
# https://gamedev.stackexchange.com/questions/44547/how-do-i-create-2d-water-with-dynamic-waves

extends Node2D

@export var water_spring_scene: PackedScene
@export var polygon: Polygon2D
@export var border: SmoothPath

@export var spread := 0.005
@export var stiffness := 0.005
@export var dampening := 0.98

@export var spring_count := 20
@export var spring_offset := 20
@export var height := 100

var springs = []

func _ready():
	for i in range(spring_count):
		var x = i * spring_offset
		var spring = water_spring_scene.instantiate() as WaterSpring
		spring.position = Vector2(x, 0)
		springs.append(spring)
		add_child(spring)
		
		if i == 0: # springs are sharing the collision shape
			spring.set_collision_width(spring_offset)
		
	splash(spring_count/2, 5000)

func _physics_process(delta):
	for _x in range(5):
		for i in range(springs.size()):
			var spring = springs[i]
			var forceFromLeft = 0
			var forceFromRight = 0
			
			if i > 0:
				var prev_spring = springs[i - 1]
				var d = prev_spring.position.y - spring.position.y
				forceFromLeft = spread * d
			if i < springs.size() - 1:
				var next_spring = springs[i + 1]
				var d = next_spring.position.y - spring.position.y
				forceFromRight = spread * d
				
			var height_offset = spring.target_height - spring.position.y
			var forceToBaseline = stiffness * height_offset
			
			var force = forceFromLeft + forceFromRight + forceToBaseline
			var accel = force / spring.mass
			spring.velocity = dampening * spring.velocity + accel
			
			spring.position.y += spring.velocity
	
	_update_border()
	_update_polygon()

func _update_polygon():
	var pos = border.curve.get_baked_points()
	pos.append(Vector2(pos[pos.size() - 1].x, height))
	pos.append(Vector2(0, height))
	polygon.polygon = pos

func _update_border():
	var curve = Curve2D.new()
	
	for pos in _spring_positions():
		curve.add_point(pos)
	
	border.curve = curve
	border.smooth(true)
	border.queue_redraw()

func _spring_positions():
	var result = []
	for spring in springs:
		result.append(spring.position)
	return result

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity = 10
