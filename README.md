<p align="center">
	<img width="256px" src="https://github.com/GodotParadise/HealthComponent/blob/main/icon.jpg" alt="GodotParadiseHealthComponent logo" />
	<h1 align="center">Godot Paradise Health Component</h1>
	
[![LastCommit](https://img.shields.io/github/last-commit/GodotParadise/HealthComponent?cacheSeconds=600)](https://github.com/GodotParadise/HealthComponent/commits)
[![Stars](https://img.shields.io/github/stars/godotparadise/HealthComponent)](https://github.com/GodotParadise/HealthComponent/stargazers)
[![Total downloads](https://img.shields.io/github/downloads/GodotParadise/HealthComponent/total.svg?label=Downloads&logo=github&cacheSeconds=600)](https://github.com/GodotParadise/HealthComponent/releases)
[![License](https://img.shields.io/github/license/GodotParadise/HealthComponent?cacheSeconds=2592000)](https://github.com/GodotParadise/HealthComponent/blob/main/LICENSE.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&logo=github)](https://github.com/godotparadise/HealthComponent/pulls)
[![](https://img.shields.io/discord/1167079890391138406.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/XqS7C34x)
[![Kofi](https://badgen.net/badge/icon/kofi?icon=kofi&label)](https://ko-fi.com/bananaholograma)
</p>

[![es](https://img.shields.io/badge/lang-es-yellow.svg)](https://github.com/GodotParadise/HealthComponent/blob/main/locale/README.es-ES.md)

- - -
Effortlessly simulate health and damage for entities within your video game.

This component handles all aspects related to taking damage and managing health on the parent node. While typically added to a `CharacterBody2D`, there are no limitations preventing its use with a `StaticRigidBody2D`, allowing you to imbue life into objects like trees or other in-game elements.

- [Requirements](#requirements)
- [✨Installation](#installation)
	- [Automatic (Recommended)](#automatic-recommended)
	- [Manual](#manual)
	- [CSharp version](#csharp-version)
- [Getting Started](#getting-started)
	- [\_Ready()](#_ready)
- [Examples](#examples)
- [Exported parameters](#exported-parameters)
- [Accessible normal variables](#accessible-normal-variables)
- [Functionality](#functionality)
	- [❤️‍🩹Taking damage](#️taking-damage)
	- [💓Healing](#healing)
	- [💚Health regeneration per second](#health-regeneration-per-second)
- [💛Invulnerability](#invulnerability)
- [😵When health reachs zero](#when-health-reachs-zero)
	- [Death manual check](#death-manual-check)
- [➗Percentage of actual health](#percentage-of-actual-health)
- [📊Multiple health bars](#multiple-health-bars)
- [📶Signals](#signals)
- [✌️You are welcome to](#️you-are-welcome-to)
- [🤝Contribution guidelines](#contribution-guidelines)
- [📇Contact us](#contact-us)


# Requirements
📢 We don't currently give support to Godot 3+ as we focus on future stable versions from version 4 onwards
* Godot 4.0+

# ✨Installation
## Automatic (Recommended)
You can download this plugin from the official [Godot asset library](https://godotengine.org/asset-library/asset/2039) using the AssetLib tab in your godot editor. Once installed, you're ready to get started
##  Manual 
To manually install the plugin, create an **"addons"** folder at the root of your Godot project and then download the contents from the **"addons"** folder of this repository
## CSharp version
This plugin has also been written in C# and you can find it on [HealthComponentCSharp](https://github.com/GodotParadise/HealthComponentCSharp)

# Getting Started
Incorporate this component as a child node in the location where you intend to implement life and damage mechanics. Simply define the initial values you wish to assign to this component.

![health-component-add](https://github.com/GodotParadise/HealthComponent/blob/main/images/health-component-child-node_add.png)
- - -
![health-component-added](https://github.com/GodotParadise/HealthComponent/blob/main/images/health-component-child-node.png)

## _Ready()
When this component becomes ready in the scene tree, a series of steps are carried out:

1. Ensure that the current health does not exceed the maximum health.
2. Set up the health regeneration timer.
3. Set up the invulnerability timer.
4. If the health regeneration per second exceeds zero, activate health regeneration.
5. Establish a connection to its own `health_changed` signal. Whenever the health changes, this signal is triggered. If health regeneration is enabled, it is also triggered, and if the current health reaches zero, a `died` signal is emitted.
6. Establish a connection to its own `died` signal. Once this signal is emitted, the built-in timers within the component are halted.

# Examples
We usually have an [examples](https://github.com/GodotParadise/HealthComponent/tree/main/examples) folder in our repositories to showcase how to use the plugin in a specific context.

In this case we have a available a simple progress bar that is monitoring the health component to update every time a change happen:

![health-component-showcase](https://github.com/GodotParadise/HealthComponent/blob/main/images/health_component_showcase.gif)


# Exported parameters
- **Max health** *(its maximum achievable health)*
- **Health overflow percentage** *(health percentage that can be surpassed when life-enhancing methods such as healing or shielding are used)*
- **Current Health** *(the actual health of the node)*
- **Health regen** *(The amount of health regenerated each tick)*
- **Health regen tick time** *(tick time defined where the health regen is applied)*
- **Is Invulnerable** *(the invulnerability flag, when is true no damage is received but can be healed)*
- **Invulnerability time** *(how long the invulnerability will last, set this value as zero to be an indefinite period)*

# Accessible normal variables
- **max_health_overflow**
- **enum TYPES {HEALTH, REGEN, DAMAGE}**
- **invulnerability_timer**
- **health_regen_timer**

The `max_health_overflow` is a computed variable that represents the sum of the maximum health and the applied health overflow percentage.

Example: `max_health of 120 and health overflow percentage of 15% = 138`
You have a maximum normal health of 120 but can be surpassed a 15% so our new limit is 138. This can be useful to implement shield mechanics where you need to separate this type of health.

# Functionality
## ❤️‍🩹Taking damage
To subtract a specific amount of health, you can effortlessly invoke the `damage()` function within the component. 
This triggers the emission of a `health_changed` signal each time damage is inflicted. Moreover, the component constantly monitors if the current health has plummeted to zero, subsequently triggering a died signal.
It's worth noting that the component is autonomously connected to its own `died` signal, concurrently ceasing the `health_regen_timer` and `invulnerability_timer`. 

If the `is_invulnerable` variable is set to true, any incoming damage, regardless of its magnitude, will be disregarded. Nevertheless, the standard signal broadcasting will persist as expected.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.damage(10)
health_component.damage(99)

# Parameter is treated as absolute value
health_component.damage(-50) # translate to 50 inside the function
```

## 💓Healing
The functionality mirrors that of the damage function, but in this instance, health is added to the component. It's important to note that the healing process can never surpass the predetermined `max_health_overflow`. 

Following each execution of the health function, a `health_changed` signal is emitted.
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.health(25)
# Parameter is treated as absolute value
health_component.health(-50)
```
## 💚Health regeneration per second
By default, health regeneration occurs every second. When the health component invokes the `damage()` function, regeneration is activated until the maximum health is reached, at which point it deactivates.
You have the flexibility to dynamically adjust the rate of regeneration per second using the `enable_health_regen` function. Alternatively, you can set it to zero to disable health regeneration altogether:
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_health_regen(10)
# or disable it
health_component.enable_health_regen(0)
```
# 💛Invulnerability
You have the ability to toggle invulnerability on or off through the `enable_invulnerability` function. By providing the enable parameter *(a boolean)*, you can specify whether invulnerability is activated or not. Additionally, you can set a time duration *(in seconds)* during which the entity will be invulnerable. Once the specified time limit is reached, invulnerability will be deactivated:
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_invulnerability(true, 2.5)
# You can deactivating it manually with
health_component.enable_invulnerability(false)
```
# 😵When health reachs zero
This component solely emits a `died` signal, offering you the flexibility to tailor the behavior to your game's needs. By establishing a connection to this signal, you can trigger animations, function calls, collect statistics, and perform other relevant actions to customize the experience according to your game's requirements

## Death manual check
Perform a manual check to ascertain if the entity has entered the death state. If you wish to manually determine this state, you can utilize the `check_is_death` function. This function emits the `died signal` if the current health reaches zero.
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

var is_dead: bool = health_component.check_is_death()
```
# ➗Percentage of actual health
If you intend to exhibit a health bar UI, you can access the health percentage format through the `get_health_percent()` function. This function returns a dictionary structured as follows:
```py
# For instance, if 80% of the maximum health represents the current health:

{
   "current_health_percentage": 0.8,
   "overflow_health_percentage": 0.0,
   "overflow_health": 0
}

# Similarly, considering a maximum health of 100, a health overflow percentage of 20.0, and a current health of 120:

{ "current_health_percentage": 1.0,
   "overflow_health_percentage": 0.2,
   "overflow_health": 20
}
```
This information can aid in accurately representing the health status and overflow in a visual health bar.

# 📊Multiple health bars
To achieve this mechanic you can simple add multiple health components as childs on the target node and create a basic chain responsibility logic using the died signal. This is a very basic example and we recommend that you adapt it to your needs if they are a little more complex, we just want to give you a basic idea.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent
@onready var health_component2 = $HealthComponent2 as GodotParadiseHealthComponent
@onready var health_component3 = $HealthComponent3 as GodotParadiseHealthComponent

var life_bars := [health_component, health_component2, health_component3]

func _ready():
	life_bars.back().died.connect(on_life_bar_consumed)
	
func on_life_bar_consumed():
	var last_life_bar = life_bars.pop_back()
	last_life_bar.died.disconnect(on_life_bar_consumed)

	if life_bars.size() > 0:
		life_bars.back().died.connect(on_life_bar_consumed)

	## Continue the logic...
```

# 📶Signals
```py
### 
# You can access the action type in the health_changed signal
# to determine what kind of action was taken and act accordingly to the flow of your game.
###

enum TYPES {
	DAMAGE,
	HEALTH,
	REGEN
}

signal health_changed(amount: int, type: TYPES)
signal invulnerability_changed(active: bool)
signal died
```

# ✌️You are welcome to
- [Give feedback](https://github.com/GodotParadise/HealthComponent/pulls)
- [Suggest improvements](https://github.com/GodotParadise/HealthComponent/issues/new?assignees=BananaHolograma&labels=enhancement&template=feature_request.md&title=)
- [Bug report](https://github.com/GodotParadise/HealthComponent/issues/new?assignees=BananaHolograma&labels=bug%2C+task&template=bug_report.md&title=)

GodotParadise is available for free.

If you're grateful for what we're doing, please consider a donation. Developing GodotParadise requires massive amount of time and knowledge, especially when it comes to Godot. Even $1 is highly appreciated and shows that you care. Thank you!


- - -
# 🤝Contribution guidelines
**Thank you for your interest in Godot Paradise!**
To ensure a smooth and collaborative contribution process, please review our [contribution guidelines](https://github.com/GodotParadise/HealthComponent/blob/main/CONTRIBUTING.md) before getting started. These guidelines outline the standards and expectations we uphold in this project.

**📓Code of Conduct:** We strictly adhere to the [Godot code of conduct](https://godotengine.org/code-of-conduct/) in this project. As a contributor, it is important to respect and follow this code to maintain a positive and inclusive community.

- - -

# 📇Contact us
If you have built a project, demo, script or example with this plugin let us know and we can publish it here in the repository to help us to improve and to know that what we do is useful.
