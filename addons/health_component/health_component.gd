## Created by https://github.com/GodotParadise organization with LICENSE MIT
# There are no restrictions on modifying, sharing, or using this component commercially
# We greatly appreciate your support in the form of stars, as they motivate us to continue our journey of enhancing the Godot community
# ***************************************************************************************
# This component provides complete control over damage handling and health management for the parent node. 
# It is commonly used with a "CharacterBody2D" but can also be applied to a "StaticRigidBody2D," 
# allowing you to add health management to objects like trees or in-game elements, 
##

class_name GodotParadiseHealthComponent extends Node

signal health_changed(amount: int, type: TYPES)
signal invulnerability_changed(active: bool)
signal died

@export_group("Health Parameters")
## Its maximum achievable health
@export var MAX_HEALTH: int = 100
## Health percentage that can be surpassed when life-enhancing methods such as healing or shielding are used.
@export var HEALTH_OVERFLOW_PERCENTAGE: float = 0.0
## The actual health of the node
@export var CURRENT_HEALTH: int:
	set(value):
		CURRENT_HEALTH = clamp(value, 0, max_health_overflow)

@export_group("Additional Behaviors")
## The amount of health regenerated each second
@export var HEALTH_REGEN: int = 0
## Every tick it applies the health regen amount value
@export var HEALTH_REGEN_TICK_TIME : float = 1.0
## The invulnerability flag, when is true no damage is received but can be healed
@export var IS_INVULNERABLE: bool = false:
	set(value):
		if IS_INVULNERABLE != value:
			invulnerability_changed.emit(value)
		
		IS_INVULNERABLE = value
## How long the invulnerability will last, set this value as zero to be an indefinite period
@export var INVULNERABILITY_TIME: float = 1.0

enum TYPES {
	DAMAGE,
	HEALTH,
	REGEN
}

## TIMERS ##
var invulnerability_timer: Timer
var health_regen_timer: Timer

var max_health_overflow: int:
	get:
		return MAX_HEALTH + (MAX_HEALTH * HEALTH_OVERFLOW_PERCENTAGE / 100)


func _ready():
	enable_health_regen(HEALTH_REGEN)
	enable_invulnerability(IS_INVULNERABLE, INVULNERABILITY_TIME);
	
	health_changed.connect(on_health_changed)
	died.connect(on_died)


func damage(amount: int):
	if IS_INVULNERABLE: 
		amount = 0
	
	amount = absi(amount)
	CURRENT_HEALTH = max(0, CURRENT_HEALTH - amount)
	
	health_changed.emit(amount, TYPES.DAMAGE)


func health(amount: int, type: TYPES = TYPES.HEALTH):
	amount = absi(amount)
	CURRENT_HEALTH += amount
	
	health_changed.emit(amount, type)
	

func check_is_dead() -> bool:
	var is_dead: bool = CURRENT_HEALTH == 0
	
	if is_dead:
		died.emit()

	return is_dead


func get_health_percent() -> Dictionary:
	var current_health_percentage = snappedf(CURRENT_HEALTH / float(MAX_HEALTH), 0.01)
	
	return {
		"current_health_percentage": minf(current_health_percentage, 1.0),
		"overflow_health_percentage": maxf(0.0, current_health_percentage - 1.0),
		"overflow_health": max(0, CURRENT_HEALTH - MAX_HEALTH)
	}
	

func enable_invulnerability(enable: bool, time: float = INVULNERABILITY_TIME):
	IS_INVULNERABLE = enable;
	INVULNERABILITY_TIME = time;

	_create_invulnerability_timer(INVULNERABILITY_TIME);

	if IS_INVULNERABLE:
		if INVULNERABILITY_TIME > 0:
			invulnerability_timer.start()
	else:
		invulnerability_timer.stop()


func enable_health_regen(amount: int = HEALTH_REGEN, time: float = HEALTH_REGEN_TICK_TIME):
	HEALTH_REGEN = amount
	HEALTH_REGEN_TICK_TIME = time;
	
	_create_health_regen_timer(HEALTH_REGEN_TICK_TIME)
	
	if health_regen_timer:
		if CURRENT_HEALTH >= MAX_HEALTH and (health_regen_timer.time_left > 0 or HEALTH_REGEN <= 0):
			health_regen_timer.stop()
			return
		
		if HEALTH_REGEN > 0:
			if time != health_regen_timer.wait_time:
				health_regen_timer.stop();
				health_regen_timer.wait_time = time;
			
			if not health_regen_timer.time_left > 0:
				health_regen_timer.start()


func _create_health_regen_timer(time: float = HEALTH_REGEN_TICK_TIME):
	if health_regen_timer:
		if health_regen_timer.wait_time != time:
			health_regen_timer.stop()
			health_regen_timer.wait_time = time
	else:
		health_regen_timer = Timer.new()
		
		health_regen_timer.name = "HealthRegenTimer"
		health_regen_timer.wait_time = time
		health_regen_timer.one_shot = false
		
		add_child(health_regen_timer)
		
		health_regen_timer.timeout.connect(on_health_regen_timer_timeout)

func _create_invulnerability_timer(time: float = INVULNERABILITY_TIME):
	if invulnerability_timer:
		if invulnerability_timer.wait_time != time:
			invulnerability_timer.stop()
			invulnerability_timer.wait_time = time
	else:
		invulnerability_timer = Timer.new()
		
		invulnerability_timer.name = "InvulnerabilityTimer"
		invulnerability_timer.wait_time = time
		invulnerability_timer.one_shot = true
		invulnerability_timer.autostart = false
		
		add_child(invulnerability_timer)
		
		invulnerability_timer.timeout.connect(on_invulnerability_timer_timeout)
		

## SIGNAL CALLBACKS ##
func on_health_changed(amount: int, type: TYPES):
	if type == TYPES.DAMAGE:
		enable_health_regen()
		Callable(check_is_dead).call_deferred()


func on_died():
	health_regen_timer.stop()
	invulnerability_timer.stop()
	

func on_health_regen_timer_timeout():
	health(HEALTH_REGEN, TYPES.REGEN)

		
func on_invulnerability_timer_timeout():
	enable_invulnerability(false)
