extends Node2D

@export var fish_reward: FishReward

@onready var player := $Fisher
@onready var hooked_timer = $HookedTimer

var first_catch := false
var currently_hooked = -1

func _ready():
	GameManager.caught_fish.connect(func(id): fish_reward.start(id, first_catch))

func _on_hooked_timer_timeout():
	currently_hooked = GameManager.get_random_fish()
	if currently_hooked < 0:
		print("Hooked invalid fish. This should not happen")
		return
	
	print("Hooked fish %s" % currently_hooked)
	player.hooked_fish()
	first_catch = not GameManager.has_unlocked_fish(currently_hooked)


func _on_fisher_caught_fish():
	if currently_hooked > 0:
		GameManager.add_fish(currently_hooked)


func _on_fisher_lost_fish():
	hooked_timer.start()


func _on_fisher_start_fish():
	hooked_timer.start()


func _on_move_aquarium_pressed():
	GameManager.go_to_aquarium()
