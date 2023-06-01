extends Control

signal changed()

@export var hour_label: Label
@export var min_label: Label

@export var timer: Timer

var hours = 0
var minutes = 0

func _process(delta):
	var dt = Time.get_datetime_dict_from_system()
	if minutes != dt.minute or hours != dt.hour:
		hours = dt.hour
		minutes = dt.minute
		_update_labels()

func _update_labels():
	hour_label.text = _with_zero(hours)
	min_label.text = _with_zero(minutes)
	changed.emit()

func _with_zero(num: int) -> String:
	if num < 10:
		return "0" + str(num)
	return str(num)
