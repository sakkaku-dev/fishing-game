extends Node

signal caught_fish(id)

const FISH_ICON_FOLDER = "res://assets/fishing_icons/fishes/"
const SAVE_SLOT = 0

var fish_data := []
var aquarium := []
var unlocked_fish := []

func _ready() -> void:
	caught_fish.connect(func(id):
		if not has_unlocked_fish(id):
			unlocked_fish.append(id)
		
		aquarium.append(id)
	)

func go_to_fishing():
	get_tree().change_scene_to_file("res://src/game.tscn")

func go_to_aquarium():
	get_tree().change_scene_to_file("res://src/aquarium.tscn")

func add_fish():
	var fish_id = 1
	caught_fish.emit(fish_id)

func load_fish_icon(id: int):
	return load(FISH_ICON_FOLDER + "sprite_%s.png" % [id - 1])

func has_unlocked_fish(id: int):
	return id in unlocked_fish
