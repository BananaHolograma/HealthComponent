<p align="center">
	<img width="256px" src="https://github.com/GodotParadise/health-component/blob/main/icon.jpg" alt="GodotParadiseHealthComponent logo" />
	<h1 align="center">Godot Paradise Health Component</h1>
</p>

Simula sin esfuerzo la salud y el daño para las entidades dentro de tu videojuego.

Este componente aborda todos los aspectos relacionados con recibir daño y gestionar la salud en el nodo principal. Aunque normalmente se agrega a un `CharacterBody2D`, no hay limitaciones que impidan su uso con un `StaticRigidBody2D` o `RigidBody2D` , lo que te permite dar vida a objetos como árboles u otros elementos dentro del juego.

- [Requerimentos](#requerimentos)
- [Instalacion](#instalacion)
	- [Automatica (Recommendada)](#automatica-recommendada)
	- [Manual](#manual)
- [🐱‍🏍Como empezar](#como-empezar)
- [Parametros exportables](#parametros-exportables)
- [Variables normales accessibles](#variables-normales-accessibles)
- [\_Ready()](#_ready)
	- [Sufrir daño](#sufrir-daño)
	- [Healing](#healing)
	- [Regeneración de vida por segundo](#regeneración-de-vida-por-segundo)
- [Invulnerabilidad](#invulnerabilidad)
- [Cuando la vida alcanza cero](#cuando-la-vida-alcanza-cero)
	- [Comprobación manual de muerte](#comprobación-manual-de-muerte)
- [Porcentaje de la vida actual](#porcentaje-de-la-vida-actual)
- [Multiples barras de vida](#multiples-barras-de-vida)
- [Signals](#signals)
- [Eres bienvenido a](#eres-bienvenido-a)
- [Guía de contribución](#guía-de-contribución)
- [Contáctanos](#contáctanos)

# Requerimentos
- Godot 4+

# Instalacion
## Automatica (Recommendada)
Puedes descargar este plugin desde la página oficial de [Godot]((https://godotengine.org/asset-library/asset/2039)) usando la pestaña **AssetLib** en tu editor. Una vez instalado ya y activado ya tendrás disponible el nuevo nodo para añadir.
##  Manual
Para instalarlo de forma manual, crea una carpeta **"addons"** en la raiz de tu proyecto y descarga el contenido de la carpeta **"addons"** de este repositorio en ella.
# 🐱‍🏍Como empezar
Añade este componente como hijo del nodo al que le quieres asignar la lógica de utilizar vida y mecánicas de daño. Es tan simple como definir los parámetros iniciales en las variables que permite editar este componente.


# Parametros exportables
- **Max health** *(la vida máxima que puede alcanzar)*
- **Health overflow percentage** *(el porcentaje de salud que puede superarse cuando se utilizan métodos para mejorar la vida, como la curación o el escudo)*
- **Current Health** *(la vida actual del nodo)*
- **Health regen per second** *(la cantidad de vida que se regenera cada segundo, dejarlo a 0 para tenerlo desactivado)*
- **Is Invulnerable** *(cuando está activado el nodo no puede recibir daño pero si puede ser curado)*
- **Invulnerability time** *(cuanto dura la invulnerabilidad cuando esta se activa, dejarlo a 0 para tenerlo con duración indefinida)*

# Variables normales accessibles
- **max_health_overflow**
- **enum TYPES {HEALTH, REGEN, DAMAGE}**
- **invulnerability_timer**
- **health_regen_timer**

La variable `max_health_overflow`  es computada y representa la suma de la vida maxima con el porcentaje `health_overflow_percentage` aplicado.

Ejemplo: `max_health of 120 and health overflow percentage of 15% = 138`
Tienes una vida maxima de 120 pero puede ser sobrepasada un 15% por lo que el nuevo limite sería 138. Esto puede ser util para implementar mecánicas de escudo donde necesitas separar este tipo de vida y saber cual es la normal y cual la que sobrepasa el límite.


# _Ready()
Cuando este componente se inicializa en el arbol de escenas una serie de pasos se ejecutan:

1. Se asegura que la vida actual no supera la vida máxima definida
2. Inicializa el temporizador de regeneración de vida para ser usado
3. Inicializa el temporizador de invulnerabilidad para ser usado.
4. Si la regeneración por segundo definida es mayor que cero, esta se activa y utiliza el temporador cuando detecta que la vida no es la máxima.
5. Establece una conexión a su propia señal `health_changed`. Cada vez que la vida cambia, esta señal es emitida. Si la vida alcanza cero la señal de `died` es emitida.
6. Establece una conexión a su propia señal `died`. Una vez esta señal se emite, los temporizadores se paran.

## Sufrir daño
Para sufrir una cantidad especifica de daño, puedes utilizar la función `damage()` que viene integrada en el component. Esto emite la señal `health_changed` cada vez que se inflje daño. Constantemente el componente monitorea si la vida ha sido bajado a cero y consecuentemente emitiendo la señal de `died`.
Está bien aclarar de nuevo que una vez esta señal es emitida, los temporizadores creados se paran para que no haya ni regeneración de vida ni invulnerabilidad.

Si la variable `is_invulnerable` está activa, cualquier daño sin importar su magnitud será descartado. Sin embargo, la señal `health_changed` seguirá emitiendose y se podrá seguir usando la curación.


```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.damage(10)
health_component.damage(99)

# El parámetro es tratado siempre como un valor absoluto
health_component.damage(-50) # Se transforma a 50 dentro de la función
```

## Healing
Esta funcionalidad refleja de forma contraria la de daño. La cantidad de curación recibida nunca podrá sobrepasar el valor que tenga la variable computada `max_health_overflow`. En cada ejecución la señal `health_changed` es emitida.
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.health(25)
# Parameter is treated as absolute value
health_component.health(-50)
```
## Regeneración de vida por segundo
Por defecto la regeneración ocurre cada segundo. Cuando el se utiliza la función `damage()` y la cantidad se resta a la vida, la regeneración es activada hasta que la vida máxima es alcanzada en cuyo caso será desactivada hasta que se reduzca la vida de nuevo.
Tienes la flexibilidad de adjustar la cantidad de rgeneración por segundo utilizando la función `enable_health_regen`. Alternativamente puedes dejarla con valor 0 para desactivarla:
```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_health_regen(10)
# or disable it
health_component.enable_health_regen(0)
```
# Invulnerabilidad
Tienes la habilidad de alternar la invulnerabilidad a través de la funcion `enable_invulnerability`. Recibe dos parametros, si se quiere activar y el tiempo que deseamos. Una vez este tiempo se alcanza la invulnerabilidad se desactivará hasta que se active manualmente de nuevo.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

health_component.enable_invulnerability(true, 2.5)
# You can deactivating it manually with
health_component.enable_invulnerability(false)
```
# Cuando la vida alcanza cero
El componente por si mismo cuando detecta que la vida es cero emite la señal `died` ofreciendo la flexibilidad para construir el conportamiento que tu juego necesita en lugar de simplemente llamar a `queue_free()`. Conectandote a esta señal puedes reaccionar con animaciones, callbacks, recolectar estadísticas o ejecutar otras acciones relevantes que necesites para personalizar la experiencia acorde a los requerimentos de tu juego.

## Comprobación manual de muerte
Realiza una comprobación manual para determinar si la entidad ha alcanzado una vida de cero. Si desea determinar manualmente este estado, puede utilizar la función `check_is_death`. Esta función emite la señal `died`  si la salud actual llega a cero.

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent

var is_dead: bool = health_component.check_is_death()
```
# Porcentaje de la vida actual
Si tu intención es mostrar una barra de vida u otro tipo de interfaz, puedes acceder a la información de tu componente de vida en formato porcentaje para obtener la información relevante usando la funcion `get_health_percent()`. El porcentaje se representa del 0 al 1 donde 1 es 100%

 Esta funcion retorna un diccionario de la siguiente forma:
```py
# Por ejemplo aqui nos dice que tenemos un 80% respecto a nuestra vida maxima y no hay overflow

{
   "current_health_percentage": 0.8,
   "overflow_health_percentage": 0.0,
   "overflow_health": 0
}

# De forma similar, si consideramos una vida maxima de 100 este diccionario nos indica que tenemos un overflow del 20%

{ "current_health_percentage": 1.0,
   "overflow_health_percentage": 0.2,
   "overflow_health": 20
}
```
Esta información puede ayudar a representar con precisión el estado de salud y el desbordamiento en una barra de salud visual.

# Multiples barras de vida
Para conseguir esta mecánica se podría conseguir de forma simple añadiendo multiples componentes de vida al nodo objetivo creando una lógica de cadena de responsabilidad usando la señal `died` como recurso. Esto es un ejemplo muy sencillo pero recomendamos que lo adaptes a tus necesidades si estas son un poco mas complejas, solo se muestra una idea básica que puede ser implementada:

```py
@onready var health_component = $HealthComponent as GodotParadiseHealthComponent
@onready var health_component2 = $HealthComponent2 as GodotParadiseHealthComponent
@onready var health_component3 = $HealthComponent3 as GodotParadiseHealthComponent

## Inicializamos los componentes y los guardamos en un array
@onready var life_bars := [health_component, health_component2, health_component3]

## Nos conectamos a la señal died de la ultima barra
func _ready():
	life_bars.back().died.connect(on_life_bar_consumed)

## Cuando esta emital la señal de died quiere decir que la vida es cero
func on_life_bar_consumed():
	var last_life_bar = life_bars.pop_back()

	## Si todavia hay componentes nos conectamos a la señal del siguiente y asi sucesivamente...
	if not life_bars.is_empty():
		life_bars.back().died.connect(on_life_bar_consumed)

	## Continuar aqui con tu lógica..
```

# Signals
```py
### 
# Puedes acceder al tipo de action (definida en el enumerado) en la señal health_changed 
# Asi podras determinar que flujo quieres tomar segun el tipo de acción que ha cambiado la vida
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

# Eres bienvenido a
- [Give feedback](https://github.com/godotessentials/2d-essentials/pulls)
- [Suggest improvements](https://github.com/godotessentials/2d-essentials/issues/new?assignees=s3r0s4pi3ns&labels=enhancement&template=feature_request.md&title=)
- [Bug report](https://github.com/godotessentials/2d-essentials/issues/new?assignees=s3r0s4pi3ns&labels=bug%2C+task&template=bug_report.md&title=)

- - -
# Guía de contribución
**¡Gracias por tu interes en Godot Paradise!**
Para garantizar un proceso de contribución fluido y colaborativo, revise nuestras [directrices de contribución](https://github.com/godotessentials/2d-essentials/blob/master/CONTRIBUTING.md) antes de empezar. Estas directrices describen las normas y expectativas que mantenemos en este proyecto.


**Código de conducta:** En este proyecto nos adherimos estrictamente al código de conducta Godot. Como colaborador, es importante respetar y seguir este código para mantener una comunidad positiva e inclusiva.
- - -


# Contáctanos
Si has construido un proyecto, demo, script o ejemplo con este plugin háznoslo saber y podremos publicarlo aquí en el repositorio para ayudarnos a mejorar y saber que lo que hacemos es útil.