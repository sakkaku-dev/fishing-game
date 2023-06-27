extends Node2D

@export var rope_part_scene: PackedScene
@export var hook_scene: PackedScene
@export var parts := 10

@onready var start_part: RopePart = $StartPart
@onready var line: Line2D = $Line2D

func _ready():
	var current := start_part
	for i in range(parts):
		var part = rope_part_scene.instantiate()
		add_child(part)
		current.connect_part(part)
		current = part
		
	var hook = hook_scene.instantiate()
	add_child(hook)
	current.connect_part(hook)
	
	for child in get_children():
		child.global_position = global_position

func _process(_delta):
	var pos = []
	for child in get_children():
		pos.append(child.position)
	
	line.points = pos
