<p align="center">
	<img width="256px" src="https://github.com/GodotParadise/health-component/blob/main/icon.jpg" alt="GodotParadiseHealthComponent logo" />
	<h1 align="center">Godot Paradise Health Component</h1>
</p>

Effortlessly simulate health and damage for entities within your video game.

This component handles all aspects related to taking damage and managing health on the parent node. While typically added to a `CharacterBody2D`, there are no limitations preventing its use with a `StaticRigidBody2D`, allowing you to imbue life into objects like trees or other in-game elements.

# Requirements
- Godot 4+

# ✨Installation
## Automatic (Recommended)
You can download this plugin from the official [Godot asset library](https://godotengine.org/asset-library/asset/2039) using the AssetLib tab in your godot editor. Once installed, you're ready to get started
##  Manual 
To manually install the plugin, create an **"addons"** folder at the root of your Godot project and then download the contents from the **"addons"** folder of this repository
# 🐱‍🏍Getting started
Incorporate this component as a child node in the location where you intend to implement life and damage mechanics. Simply define the initial values you wish to assign to this component.


# Exported parameters
- **Max health** *(its maximum achievable health)*
- **Health overflow percentage** *(health percentage that can be surpassed when life-enhancing methods such as healing or shielding are used)*
- **Current Health** *(the actual health of the node)*
- **Health regen per second** *(The amount of health regenerated each second)*
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

# _Ready()
When this component becomes ready in the scene tree, a series of steps are carried out:

1. Ensure that the current health does not exceed the maximum health.
2. Set up the health regeneration timer.
3. Set up the invulnerability timer.
4. If the health regeneration per second exceeds zero, activate health regeneration.
5. Establish a connection to its own `health_changed` signal. Whenever the health changes, this signal is triggered. If health regeneration is enabled, it is also triggered, and if the current health reaches zero, a `died` signal is emitted.
6. Establish a connection to its own `died` signal. Once this signal is emitted, the built-in timers within the component are halted.

## Taking damage
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

# You are welcome to
- [Give feedback](https://github.com/GodotParadise/health-component/pulls)
- [Suggest improvements](https://github.com/GodotParadise/health-component/issues/new?assignees=s3r0s4pi3ns&labels=enhancement&template=feature_request.md&title=)
- [Bug report](https://github.com/GodotParadise/health-component/issues/new?assignees=s3r0s4pi3ns&labels=bug%2C+task&template=bug_report.md&title=)

- - -
# Contribution guidelines
**Thank you for your interest in Godot Paradise!**

To ensure a smooth and collaborative contribution process, please review our [contribution guidelines](https://github.com/GodotParadise/health-component/blob/master/CONTRIBUTING.md) before getting started. These guidelines outline the standards and expectations we uphold in this project.

**Code of Conduct:** We strictly adhere to the Godot code of conduct in this project. As a contributor, it is important to respect and follow this code to maintain a positive and inclusive community.

- - -


# Contact us
If you have built a project, demo, script or example with this plugin let us know and we can publish it here in the repository to help us to improve and to know that what we do is useful.
