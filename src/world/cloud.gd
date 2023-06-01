extends CharacterBody2D

@export var speed := 5
@export var dir := Vector2.LEFT

@export var sprite: Sprite2D

const CLOUD_1 = preload("res://assets/Clouds_1.png")
const CLOUD_2 = preload("res://assets/Clouds_2.png")
const CLOUD_3 = preload("res://assets/Clouds_3.png")
const CLOUDS = [CLOUD_1, CLOUD_2, CLOUD_3]

func _ready():
	sprite.texture = CLOUDS.pick_random()

func _process(delta):
	velocity = dir * speed
	move_and_slide()
