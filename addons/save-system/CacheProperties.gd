class_name CacheProperties
extends Node

@export var properties: Array[String]
@export var node_path: NodePath
@onready var node := get_node(node_path) if node_path else get_parent()

var logger = Logger.new("SaveProperties")


func _ready():
	add_to_group(CacheManager.PERSIST_GROUP)


func save_data():
	var data = {}
	for prop in properties:
		data[prop] = node.get(prop)
	return data


func load_data(data: Dictionary):
	for prop in data:
		node.set(prop, data[prop])
