extends TextureButton

signal buy_item(res)

@export var res: ShopResource

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var count: Label = $Count

func _ready() -> void:
	mouse_entered.connect(func():
		if not disabled:
			modulate = Color.WHITE
	)
	mouse_exited.connect(func(): modulate = Color.DIM_GRAY)
	modulate = Color.DIM_GRAY
	
	pressed.connect(func(): buy_item.emit(get_actual_upgrade()))
	
	update()
	GameManager.money_changed.connect(func(): update())
	
func update(r: ShopResource = res):
	texture_rect.texture = r.sprite
	if r is UpgradeResource:
		var upgrade_count := get_upgrade_count(r)
		var upgrades := all_upgrades(r)
		if upgrade_count < upgrades.size():
			var up = upgrades[upgrade_count]
			label.text = "%s" % up.price
			disabled = not GameManager.can_buy_item(up)
		else:
			label.text = "%s" % upgrades[upgrades.size() - 1].price
			disabled = true
		
		count.text = "%s/%s" % [upgrade_count, upgrades.size()]
	else:
		label.text = "%s" % r.price
		disabled = not GameManager.can_buy_item(r)
		count.text = "%sx" % GameManager.aquarium_items.count(r.type)

func get_actual_upgrade(item: ShopResource = res):
	if item is UpgradeResource:
		var upgrade_count := get_upgrade_count(item)
		var upgrades := all_upgrades(item)
		if upgrade_count >= upgrades.size():
			return null
		
		return upgrades[upgrade_count]
	return item

func all_upgrades(item: UpgradeResource) -> Array[UpgradeResource]:
	var result := [item] as Array[UpgradeResource]
	while item.successor != null:
		result.append(item.successor)
		item = item.successor
	
	return result

func get_upgrade_count(upgrade: UpgradeResource) -> int:
	return GameManager.purchased_upgrades.count(upgrade.type)
