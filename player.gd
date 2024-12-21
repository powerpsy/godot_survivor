extends CharacterBody2D

var speed: float = 500
var health: float = 100:
	set(value):
		health = value
		%Health.value = value

func _physics_process(delta):
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)

func take_damage(amount):
	health -= amount
	print(amount)

func _on_self_damage_body_entered(body):
	take_damage(body.damage)


func _on_timer_timeout():
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
