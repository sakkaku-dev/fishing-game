extends Marker2D

@export var cloud: PackedScene

@export var spawn_offset := 20.0
@export var min_spawn_time := 30.0
@export var max_spawn_timer := 180.0

@export var timer: Timer

func _ready():
	timer.timeout.connect(_on_timeout)

func _on_timeout():
	var pos = global_position
	pos.y += randf_range(-spawn_offset, spawn_offset)
	
	var node = cloud.instantiate()
	node.global_position = pos
	get_tree().current_scene.add_child(node)
	
	var next_spawn_time = randf_range(min_spawn_time, max_spawn_timer)
	print("Spawned cloud at %s. Next one in %ss" % [pos, next_spawn_time])
	timer.start(next_spawn_time)
