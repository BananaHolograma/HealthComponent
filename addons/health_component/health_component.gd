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
signal life_bar_consumed(remaining: int)
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
@export var HEALTH_REGEN_PER_SECOND: int = 0
## The invulnerability flag, when is true no damage is received but can be healed
@export var IS_INVULNERABLE: bool = false:
	set(value):
		if IS_INVULNERABLE != value:
			invulnerability_changed.emit(value)
		
		IS_INVULNERABLE = value
## How long the invulnerability will last, set this value as zero to be an indefinite period
@export var invulnerability_time: float = 1.0


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
	_create_health_regen_timer()
	_create_invulnerability_timer()
	enable_health_regen(HEALTH_REGEN_PER_SECOND)
	
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


func enable_invulnerability(enable: bool, time: float = invulnerability_time):
	if enable:
		IS_INVULNERABLE = true
		
		if invulnerability_timer == null:
			_create_invulnerability_timer(time) 
		
		invulnerability_timer.start()
	else:
		IS_INVULNERABLE = false
		
		if invulnerability_timer:
			invulnerability_timer.stop()


func enable_health_regen(amount_per_second: int = HEALTH_REGEN_PER_SECOND):
	HEALTH_REGEN_PER_SECOND = amount_per_second
	
	if health_regen_timer:
		if CURRENT_HEALTH == MAX_HEALTH and health_regen_timer.time_left > 0 or amount_per_second <= 0:
			health_regen_timer.stop()
			return
		
		if health_regen_timer.is_stopped() and HEALTH_REGEN_PER_SECOND > 0:
			health_regen_timer.start()


## DINAMIC TIMER CREATION ##
func _create_health_regen_timer(time: float = 1.0):
	if health_regen_timer == null:
		var new_health_regen_timer: Timer = Timer.new()
		
		new_health_regen_timer.name = "HealthRegenTimer"
		new_health_regen_timer.wait_time = time
		new_health_regen_timer.one_shot = false
		
		health_regen_timer = new_health_regen_timer
		add_child(new_health_regen_timer)
		
		new_health_regen_timer.timeout.connect(on_health_regen_timer_timeout)

func _create_invulnerability_timer(time: float = invulnerability_time):
	if invulnerability_timer and invulnerability_timer.wait_time != time:
		invulnerability_timer.stop()
		invulnerability_timer.wait_time = time
	else:
		var new_invulnerability_timer: Timer = Timer.new()
		
		new_invulnerability_timer.name = "InvulnerabilityTimer"
		new_invulnerability_timer.wait_time = time
		new_invulnerability_timer.one_shot = true
		new_invulnerability_timer.autostart = false
		
		invulnerability_timer = new_invulnerability_timer
		add_child(new_invulnerability_timer)
		
		new_invulnerability_timer.timeout.connect(on_invulnerability_timer_timeout)


## SIGNAL CALLBACKS ##

func on_health_changed(amount: int, type: TYPES):
	if type == TYPES.DAMAGE:
		enable_health_regen()
		Callable(check_is_dead).call_deferred()

func on_died():
	health_regen_timer.stop()
	invulnerability_timer.stop()
	
func on_health_regen_timer_timeout():
	health(HEALTH_REGEN_PER_SECOND, TYPES.REGEN)

		
func on_invulnerability_timer_timeout():
	enable_invulnerability(false)
