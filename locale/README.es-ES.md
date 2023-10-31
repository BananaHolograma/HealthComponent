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

[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/GodotParadise/HealthComponent/blob/main/README.md)

- - -
Simule sin esfuerzo la salud y el daño de las entidades dentro de tu videojuego.

Este componente maneja todos los aspectos relacionados con la recepción de daños y la gestión de la salud en el nodo padre. Aunque normalmente se añade a un `CharacterBody2D`, no hay limitaciones que impidan su uso con un `StaticRigidBody2D`, lo que le permite imbuir vida a objetos como árboles u otros elementos del juego.

- [Requerimientos](#requerimientos)
- [✨Instalacion](#instalacion)
	- [Automatica (Recomendada)](#automatica-recomendada)
	- [Manual](#manual)
	- [CSharp version](#csharp-version)
- [Como empezar](#como-empezar)
- [\_Ready()](#_ready)
- [Examples](#examples)
- [Parámetros exportados](#parámetros-exportados)
- [Variables normales accessibles](#variables-normales-accessibles)
- [Funcionalidad](#funcionalidad)
	- [❤️‍🩹Recibir daño](#️recibir-daño)
	- [💓Curación](#curación)
	- [💚Curación de vida por segundo](#curación-de-vida-por-segundo)
- [💛Invulnerabilidad](#invulnerabilidad)
- [😵Cuando la vida alcanza cero](#cuando-la-vida-alcanza-cero)
	- [Comprobacion manual de muerte](#comprobacion-manual-de-muerte)
- [➗Porcentaje de la vida actual](#porcentaje-de-la-vida-actual)
- [📊Multiple health bars](#multiple-health-bars)
- [📶Señales](#señales)
- [✌️Eres bienvenido a](#️eres-bienvenido-a)
- [🤝Normas de contribución](#normas-de-contribución)
- [📇Contáctanos](#contáctanos)



# Requerimientos
📢 No soportamos versiones inferiores de Godot 3+ ya que nos concentramos en las versiones estables del futuro a partir de la 4 en adelante.
* Godot 4.0+

# ✨Instalacion
## Automatica (Recomendada)
Puedes descargar este plugin desde la [Godot asset library](https://godotengine.org/asset-library/asset/2039) oficial usando la pestaña AssetLib de tu editor Godot. Una vez instalado, estás listo para empezar
## Manual 
Para instalar manualmente el plugin, crea una carpeta **"addons"** en la raíz de tu proyecto Godot y luego descarga el contenido de la carpeta **"addons"** de este repositorio
## CSharp version
Este plugin ha sido también escrito en C# y puedes encontrarlo en [HealthComponentCSharp](https://github.com/GodotParadise/HealthComponentCSharp)

# Como empezar
Incorpora este componente como nodo hijo en el lugar donde quieras implementar la mecánica de vida y daño. Simplemente define los valores iniciales que deseas asignar a este componente.

![health-component-add](https://github.com/GodotParadise/HealthComponent/blob/main/images/health-component-child-node_add.png)
- - -
![health-component-added](https://github.com/GodotParadise/HealthComponent/blob/main/images/health-component-child-node.png)

# _Ready()
Cuando este componente está listo en el árbol de escena, se llevan a cabo una serie de pasos:

1. Asegurarse de que la salud actual no excede la salud máxima.
2. Configurar el temporizador de regeneración de salud.
3. Configurar el temporizador de invulnerabilidad.
4. Si la regeneración de salud por segundo es superior a cero, activa la regeneración de salud.
5. Establece una conexión con su propia señal `health_changed`. Cada vez que cambia la salud, se activa esta señal. Si la regeneración de salud está activada, también se dispara, y si la salud actual llega a cero, se emite una señal `died`.
6. Establecer una conexión con su propia señal `died` Una vez que se emite esta señal, se detienen los temporizadores incorporados en el componente.

# Examples
Tenemos una carpeta [ejemplos](https://github.com/GodotParadise/HealthComponent/tree/main/examples) en casi todos nuestros repositorios para mostrar como usar el plugin en un contexto determinado.

En este caso tenemos disponible una barra de progreso simple que esta siendo actualizada segun los cambios que sucedan en el componente de vida.

![health-component-showcase](https://github.com/GodotParadise/HealthComponent/blob/main/images/health_component_showcase.gif)


# Parámetros exportados
- **Max health** *(la vida máxima alcanzable)*
- **Health overflow percentage** *(el porcentaje de vida que puede ser sobrepasado, util para simular mecanicas como escudos)*
- **Current Health** *(la vida actual del nodo)*
- **Health regen** *(la cantida de vida a regenerar segun el tiempo definido por tick)*
- **Health regen tick time** (el tiempo de cada tick para que la cantidad a regenerar sea aplicada)
- **Is Invulnerable** *(si esta activada, no se puede recibir daño pero si curación)*
- **Invulnerability time** *(cuanto va a durar la invulnerabilidad cuando se active, dejar a cero para que sea indefinido)*

# Variables normales accessibles
- **max_health_overflow**
- **enum TYPES {HEALTH, REGEN, DAMAGE}**
- **invulnerability_timer**
- **health_regen_timer**

The `max_health_overflow` es una variable computada que representa la suma de la vida maxima con el `health_overflow_percentage` aplicado.

Ejemplo: `max_health of 120 and health overflow percentage of 15% = 138`
Tienes una vida maxima normal de 120 pero puede ser sobrepasada un 15% por lo que el nuevo limite es 138. Esto puede ser util para implementar mecánicas de escudo donde necesitas separar los tipos de vida.

# Funcionalidad
## ❤️‍🩹Recibir daño
Para restar una cantidad específica de salud, puedes invocar sin esfuerzo la función `damage()` dentro del componente. 
Esto provoca la emisión de una señal `health_changed` cada vez que se inflige daño. Además, el componente controla constantemente si la salud actual ha caído en picado hasta cero, activando posteriormente una señal de `died`.
Cabe destacar que el componente se conecta de forma autónoma a su propia señal de `died`, lo que detiene simultáneamente el temporizador de regeneración de salud y el temporizador de invulnerabilidad. 

Si la variable `is_invulnerable` es verdadera, cualquier daño recibido, independientemente de su magnitud, será ignorado. No obstante, se mantendrá la emisión de señales estándar.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.damage(10)
health_component.damage(99)

# Parametro es tratado como valor absoluto
health_component.damage(-50) # Se transforma en 50 dentro de la funcion
```

## 💓Curación
Similar a la de daño pero esta vez, la cantidad es añadida como vida. Es importante anotar que el proceso de curación cuando la cantidad supera el valor de la variable `max_health_overflow` se usa este como límite.

En cada ejecución de la función, una señal `health_changed` es emitida.
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.health(25)
# Parametro es tratado como valor absoluto
health_component.health(-50) # Se transforma en 50 dentro de la funcion
```
## 💚Curación de vida por segundo
Cuando se invoca la función `damage()`, la regeneración es activada *(si health_regen es > 0)* hasta que la vida máxima es alcanzada, y en cuanto esto sucede, se desactiva.
Tienes la flexilidad de ajustar la cantidad de curación el intervalo de tiempo en el que tiene que suceder. Dejar el valor de `health_regen` a cero si se quiere deshabilitar.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_health_regen(10)
# o deshabilitarlo
health_component.enable_health_regen(0)
```
# 💛Invulnerabilidad
Tienes la posibilidad de activar o desactivar la invulnerabilidad a través de la función `enable_invulnerability`. Proporcionando el parámetro enable *(a boolean)*, puedes especificar si la invulnerabilidad está activada o no. Además, puedes establecer un tiempo de duración *(en segundos)* durante el cual la entidad será invulnerable. Una vez alcanzado el límite de tiempo especificado, la invulnerabilidad se desactivará:
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_invulnerability(true, 2.5)
# Desactivarlo de forma manual con:
health_component.enable_invulnerability(false)
```
# 😵Cuando la vida alcanza cero
El componente por si solo emite la señal `died` ofreciendote la flexibilidad de adaptar el comportamiento que tu juego necesita reaccionando a esta señal. Conectandote a ella puedes ejecutar animaciones, llamar a otras funciones, colectar estadísticas o ejecutar otras acciones relevantes para personalizar la experiencia acorde a los requerimentos de tu juego.

## Comprobacion manual de muerte
Realiza una comprobación manual para determinar si la entidad ha entrado en estado de muerte. Si deseas determinar manualmente este estado, puedes utilizar la función `check_is_death`. Esta función emite la `died` si la salud actual llega a cero.
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

var is_dead: bool = health_component.check_is_death()
```
# ➗Porcentaje de la vida actual
Si desea mostrar una barra de salud, puede acceder al formato del porcentaje de salud a través de la función `get_health_percent()`. Esta función devuelve un diccionario estructurado como sigue:
```py
# Por ejemplo, este valor indica que tiene un 80% de vida y no hay overflow.

{
   "current_health_percentage": 0.8,
   "overflow_health_percentage": 0.0,
   "overflow_health": 0
}

# De forma similar, considerando una vida maxima de 100 y un overflow de 20% podemos ver que tiene vida maxima y todo el overflow aplicado.
# por lo que su vida real sera 100 + 20

{ "current_health_percentage": 1.0,
   "overflow_health_percentage": 0.2,
   "overflow_health": 20
}
```
Esta información puede ayudar a representar con precisión el estado de salud y el desbordamiento en una barra de salud visual.

# 📊Multiple health bars
Para conseguir esta mecánica puedes simplemente añadir múltiples componentes de salud como hijos en el nodo destino y crear una lógica básica de responsabilidad en cadena usando la señal de `died`. Este es un ejemplo muy básico y te recomendamos que lo adaptes a tus necesidades si son un poco más complejas, sólo queremos darte una idea básica.

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

	## Continua la lógica
```

# 📶Señales
```py
### 
# Puedes acceder al tipo de action en la señal health_changed
# para determinar que tipo de curación / daño se llevo a cabo para reaccionar acorde al flujo de tu juego.
#
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

# ✌️Eres bienvenido a
- [Dar feedback](https://github.com/GodotParadise/HealthComponent/pulls)
- [Sugerir mejoras](https://github.com/GodotParadise/HealthComponent/issues/new?assignees=BananaHolograma&labels=enhancement&template=feature_request.md&title=)
- [Reportar bugs](https://github.com/GodotParadise/HealthComponent/issues/new?assignees=BananaHolograma&labels=bug%2C+task&template=bug_report.md&title=)

GodotParadise esta disponible de forma gratuita.

Si estas agradecido por lo que hacemos, por favor, considera hacer una donación. Desarrollar los plugins y contenidos de GodotParadise requiere una gran cantidad de tiempo y conocimiento, especialmente cuando se trata de Godot. Incluso 1€ es muy apreciado y demuestra que te importa. ¡Muchas Gracias!

- - -
# 🤝Normas de contribución
**¡Gracias por tu interes en GodotParadise!**

Para garantizar un proceso de contribución fluido y colaborativo, revise nuestras [directrices de contribución](https://github.com/godotparadise/HealthComponent/blob/main/CONTRIBUTING.md) antes de empezar. Estas directrices describen las normas y expectativas que mantenemos en este proyecto.

**📓Código de conducta:** En este proyecto nos adherimos estrictamente al [Código de conducta de Godot](https://godotengine.org/code-of-conduct/). Como colaborador, es importante respetar y seguir este código para mantener una comunidad positiva e inclusiva.
- - -


# 📇Contáctanos
Si has construido un proyecto, demo, script o algun otro ejemplo usando nuestros plugins haznoslo saber y podemos publicarlo en este repositorio para ayudarnos a mejorar y saber que lo que hacemos es útil.
