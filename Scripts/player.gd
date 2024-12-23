extends CharacterBody2D

var speed: float = 500
const acc = 50
var motion = Vector2()
var health: float = 100:
	set(value):
		health = value
		%Health.value = value

var nearest_ennemy : CharacterBody2D
var nearest_ennemy_distance : float = INF

func _physics_process(delta):
	if nearest_ennemy:
		nearest_ennemy_distance = nearest_ennemy.separation
	else:
		nearest_ennemy_distance = INF
	
	velocity = Input.get_vector("left","right","up","down") * speed
	if velocity.x > 0:
		motion.x = min(motion.x + acc, speed)
	elif velocity.x < 0:
		motion.x = max(motion.x - acc, -speed)
	else:
		motion.x = lerp(motion.x, 0.0, 0.2)
		
	if velocity.y > 0:
		motion.y = min(motion.y + acc, speed)
	elif velocity.y < 0:
		motion.y = max(motion.y - acc, -speed)
	else:
		motion.y = lerp(motion.y, 0.0, 0.2)
	
	move_and_collide(motion * delta)

func take_damage(amount):
	health -= amount

func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_timer_timeout():
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
