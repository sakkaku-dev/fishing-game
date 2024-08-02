extends Node

signal caught_fish(id)
signal day_changed()
signal money_changed()

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
}

const FISH_ICON_FOLDER = "res://assets/fishing_icons/fishes/"
const SAVE_SLOT = 0

const TAG_DAY = "day"
const TAG_NIGHT = "night"
const TAG_WARM = "warm"
const TAG_COLD = "cold"
const TAG_CARNIVORE = "carnivore"

@export_category("Fish")
@export var base_rarity_factor := 300
@export var tag_multiplier := 1.75
@export var total_rarity_multipler := 1.2

@export_category("Environment")
@export var max_day_time := 100
@export var day_start := 0
@export var night_start := 42
@export var temp_warm_start = 20

@export_category("Rarity")
@export var common_color: Color
@export var uncommon_color: Color
@export var rare_color: Color
@export var epic_color: Color
@export var legendary_color: Color

@onready var rarity_colors = {
	GameManager.Rarity.COMMON: common_color,
	GameManager.Rarity.UNCOMMON: uncommon_color,
	GameManager.Rarity.RARE: rare_color,
	GameManager.Rarity.EPIC: epic_color,
	GameManager.Rarity.LEGENDARY: legendary_color,
}

@onready var save_manager: SaveManager = $SaveManager
@onready var cache_properties: CacheProperties = $CacheProperties

var is_day := false:
	set(v):
		if is_day != v:
			day_changed.emit()
		is_day = v

var day_time := 0.0:
	set(v):
		day_time = v
		if day_time > max_day_time:
			day_time = 0.0
		
		self.is_day = day_time >= day_start and day_start < night_start

var temp := 20
var money := 0:
	set(v):
		money = v
		money_changed.emit()

var fish_data := []
var aquarium := []
var unlocked_fish := []

func _ready() -> void:
	caught_fish.connect(func(id):
		if not has_unlocked_fish(id):
			unlocked_fish.append(id)
		
		aquarium.append(id)
		_save_data()
	)
	
	_load_data()
	
func _exit_tree() -> void:
	_save_data()

func _save_data():
	save_manager.save_to_slot(SAVE_SLOT, cache_properties.save_data())

func _load_data():
	var data = save_manager.load_from_slot(SAVE_SLOT)
	if data:
		cache_properties.load_data(data)

func get_rarity(fish: Dictionary):
	var p = fish["rarity"]
	
	if p <= 0.01:
		return Rarity.LEGENDARY
	elif p <= 0.05:
		return Rarity.EPIC
	elif p <= 0.3:
		return Rarity.RARE
	elif p <= 0.6:
		return Rarity.UNCOMMON
	
	return Rarity.COMMON

func get_rarity_color(fish: Dictionary) -> Color:
	return rarity_colors[get_rarity(fish)]

func get_fish_data(fish: int):
	var found = fish_data.filter(func(x): return x["id"] == fish)
	if found.is_empty():
		print("Found no fish with the id %s" % fish)
		return
	
	if found.size() > 1:
		print("Found more than one fish with the id %s" % fish)
		
	return found[0]

func sell_fish(fish: int):
	if not fish in aquarium:
		print("No fish of id %s in your aquarium." % fish)
		return
	
	var data = get_fish_data(fish)
	self.money += data["price"]
	aquarium.erase(fish)

func go_to_fishing():
	get_tree().change_scene_to_file("res://src/game.tscn")

func go_to_aquarium():
	get_tree().change_scene_to_file("res://src/aquarium.tscn")

func _get_fish_chance(fish: Dictionary):
	var matching_tags = 0
	var tags = fish["tags"]
	
	var conditions = [
		func(): return temp >= temp_warm_start and TAG_WARM in tags,
		func(): return temp < temp_warm_start and TAG_COLD in tags,
	]
	
	if is_day and TAG_DAY in tags:
		matching_tags += 1
		for cond in conditions:
			if cond.call():
				matching_tags += 1
	elif not is_day and TAG_NIGHT in tags:
		matching_tags += 1
		for cond in conditions:
			if cond.call():
				matching_tags += 1
		
	return pow(base_rarity_factor, fish["rarity"]) * (matching_tags * tag_multiplier)

func get_catchable_fishes():
	var total_rarity = 0.0

	# Calculate the total rarity sum
	var highest_rarity = 0
	for item in fish_data:
		highest_rarity = max(_get_fish_chance(item), highest_rarity)
	
	highest_rarity *= total_rarity_multipler
	var fish_probabilities = []
	for item in fish_data:
		var probability = _get_fish_chance(item) / highest_rarity
		fish_probabilities.append([item["id"], probability, item])
	
	fish_probabilities.sort_custom(func(a, b): return a[1] > b[1])
	return fish_probabilities
	
func get_random_fish() -> int:
	var weights = []
	var cumulative_weights = []
	var cumulative_sum = 0.0
	
	# Calculate weights and cumulative weights
	for item in fish_data:
		var weight = _get_fish_chance(item)
		weights.append(weight)
		cumulative_sum += weight
		cumulative_weights.append(cumulative_sum)
	
	# Generate a random number between 0 and the total weight sum
	var total_weight = cumulative_weights[-1]
	var random_number = randf_range(0.0, total_weight)
	
	# Find the item corresponding to the random number
	for i in range(cumulative_weights.size()):
		if random_number <= cumulative_weights[i] and weights[i] != 0:
			return fish_data[i]["id"]
	
	return -1  # Fallback in case no item is selected, should not happen

func add_fish(fish):
	caught_fish.emit(fish)

func load_fish_icon(id: int):
	return load(FISH_ICON_FOLDER + "sprite_%s.png" % [id - 1])

func has_unlocked_fish(id: int):
	return id in unlocked_fish
