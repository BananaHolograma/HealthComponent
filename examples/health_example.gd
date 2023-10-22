extends Node2D

@onready var health_component = $GodotParadiseHealthComponent as GodotParadiseHealthComponent
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var health_points: Label = %HealthPoints
@onready var revive_button: Button = %ReviveButton
@onready var damage: Button = %Damage
@onready var health: Button = %Health
@onready var health_regen_check: CheckBox = %HealthRegenCheck
@onready var invulnerable_checkbox: CheckBox = %Invulnerable


func _ready():
	var health_information := health_component.get_health_percent();
	progress_bar.value = health_information["current_health_percentage"] * 100;
	health_points.text = str(health_component.CURRENT_HEALTH) + "+ {overflow} overflow points".format({"overflow": health_information["overflow_health"]})

	health_regen_check.button_pressed = health_component.HEALTH_REGEN > 0
	revive_button.visible = health_component.CURRENT_HEALTH == 0 
	
	health_component.invulnerability_changed.connect(on_invulnerability_changed)


func _on_damage_pressed():
	health_component.damage(15)


func _on_health_pressed():
	health_component.health(10)


func _on_godot_paradise_health_component_health_changed(amount, type):
	var health_information := health_component.get_health_percent();
	progress_bar.value = health_information["current_health_percentage"] * 100;
	
	health_points.text = str(health_component.CURRENT_HEALTH) + "+ {overflow} overflow points".format({"overflow": health_information["overflow_health"]})
	revive_button.visible = health_component.CURRENT_HEALTH == 0


func _on_health_regen_check_toggled(button_pressed):
	if button_pressed:	
		health_component.enable_health_regen(5)
		return
		
	health_component.enable_health_regen(0)


func _on_invulnerable_toggled(button_pressed):
	health_component.enable_invulnerability(button_pressed)


func on_invulnerability_changed(enabled):
	invulnerable_checkbox.button_pressed = enabled;


func _on_godot_paradise_health_component_died():
	pass # Replace with function body.


func _on_revive_button_pressed():
	health_component.health(health_component.MAX_HEALTH)
