class_name AquariumResource
extends ShopResource

enum Type {
	Duck,
	Treasure,
	SwimRing,
	Bottle,
	Boots,
	Weed,
	RedWeed,
	WoodLog,
}

@export var type := Type.Duck
@export var scene: PackedScene
