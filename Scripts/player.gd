extends CharacterBody2D

var speed: float = 500
const acceleration = 50
var motion = Vector2()
var health: float = 100:
	set(value):
		health = value
		%Health.value = value

var nearest_ennemy : CharacterBody2D
var nearest_ennemy_distance : float = INF

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "Level " + str(value)
		
		%XP.max_value = %XP.max_value + 10 * level

func _physics_process(delta):
	if is_instance_valid(nearest_ennemy):
		nearest_ennemy_distance = nearest_ennemy.separation
	else:
		nearest_ennemy_distance = INF
	
	velocity = Input.get_vector("left","right","up","down") * speed
	if velocity.x > 0:
		motion.x = min(motion.x + acceleration, speed)
	elif velocity.x < 0:
		motion.x = max(motion.x - acceleration, -speed)
	else:
		motion.x = lerp(motion.x, 0.0, 0.2)
		
	if velocity.y > 0:
		motion.y = min(motion.y + acceleration, speed)
	elif velocity.y < 0:
		motion.y = max(motion.y - acceleration, -speed)
	else:
		motion.y = lerp(motion.y, 0.0, 0.2)
	
	move_and_collide(motion * delta)
	check_XP()

func take_damage(amount):
	health -= amount

func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_timer_timeout():
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount
	total_XP += amount
	
func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1

func _on_magnet_area_entered(area):
	if area.has_method("follow"):
		area.follow(self)
