extends Control

#controles
@onready var input_button_scene = preload("res://UI/Options/input_button.tscn")
@onready var action_list = $Panel/TabContainer/Controle/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

func _ready():
	_create_action_list()
	

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_child():
		item.queue_free()
		
	for action in InputMap.get_actions():
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = action
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text()
		else:
			input_label.text = ""
		
		action_list.add_child(button)
