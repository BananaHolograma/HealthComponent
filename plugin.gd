@tool
extends EditorPlugin

const PLUGIN_PREFIX = "GodotParadise"


func _enter_tree():
	add_custom_type(_add_prefix("HealthComponent"), "Node", preload("res://addons/health_component/health_component.gd"), preload("res://addons/health_component/suit_hearts.svg"))


func _exit_tree():
	remove_custom_type(_add_prefix("HealthComponent"))
	
	
func _add_prefix(text: String) -> String:
	return "{prefix}{text}".format({"prefix": PLUGIN_PREFIX, "text": text}).strip_edges()
