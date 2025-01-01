extends Node2D

@export var player : CharacterBody2D
@export var ennemy : PackedScene
@export var destructible : PackedScene

var distance : float = 800
var can_spawn : bool = true

@export var ennemy_types : Array[Ennemy]

var minute : int:
	set(value):
		minute = value
		%Minute.text = str(value)

var second : int:
	set(value):
		second = value
		if second >= 10:
			second -= 10
			minute += 1
		%Second.text = str(second).lpad(2,'0')

func _physics_process(delta):
	if get_tree().get_node_count_in_group("Ennemy") < 1500:
		can_spawn = true
	else:
		can_spawn = false

func spawn(pos : Vector2, elite: bool = false):
	if not can_spawn and not elite:
		return
			
	var ennemy_instance = ennemy.instantiate()
	
	ennemy_instance.type = ennemy_types[min(minute, ennemy_types.size()-1)]
	ennemy_instance.position = pos
	ennemy_instance.player_reference = player
	ennemy_instance.elite = elite
	get_tree().current_scene.add_child(ennemy_instance)
	
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0,2 * PI))

func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())

func _on_timer_timeout():
	second += 1
	amount(second % 10)

func _on_pattern_timeout():
	for i in range(75):
		spawn(get_random_position())

func _on_elite_timeout():
	spawn(get_random_position(), true)

func _on_destructible_timeout():
	spawn_destructible(get_random_position())

func spawn_destructible(pos):
	var object_instance = destructible.instantiate()
	object_instance.position = pos
	get_tree().current_scene.add_child(object_instance)
