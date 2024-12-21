extends CharacterBody2D

@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 300
var damage : float
var elite : bool = false:
	set(value):
		elite = value
		if value:
			$Sprite2D.material = load("res://Shaders/Radar.tres")
			scale = Vector2(3,3)
			
var type : Ennemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage

func _physics_process(delta):
	velocity = (player_reference.position - position).normalized() * speed
	move_and_collide(velocity * delta)
