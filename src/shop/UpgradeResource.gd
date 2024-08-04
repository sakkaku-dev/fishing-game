class_name UpgradeResource
extends ShopResource

enum Type {
	HookIncrease,
	ReelImprove,
	BaitMeat,
	FishDetector,
}

@export var type := Type.HookIncrease
@export var successor: UpgradeResource
