extends CharacterBody2D

const acceleration = 3000
var motion = Vector2()
var health: float = 100:
	set(value):
		health = max(value, 0)
		%Health.value = value
		if health <= 0:
			get_tree().paused = true
var movement_speed : float = 300
var max_health : float = 120:
	set(value):
		max_health = value
		%Health.max_value = value
var recovery : float = 0:
	set(value):
		recovery = value
		%Recovery.text = "Recovery: " + str(value)
var armor : float = 0:
	set(value):
		armor = value
		%Armor.text = "Armor: " + str(value)
var might : float = 1.0:
	set(value):
		might = value
		%Might.text = "Might: " + str(value)
var area : float = 0
var magnet : float = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 100 + value
var growth : float = 1

var nearest_ennemy
var nearest_ennemy_distance : float = 300 + area

var gold : int = 0:
	set(value):
		gold = value
		%Gold.text = "Gold: " + str(value)

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "Level " + str(value)
		%Options.show_option()
		
		%XP.max_value = %XP.max_value + 10 * level

func _ready():
	Persistence.gain_bonus_stats(self)

func _physics_process(delta):
	if is_instance_valid(nearest_ennemy):
		nearest_ennemy_distance = nearest_ennemy.separation
	else:
		nearest_ennemy_distance = 300 + area
		nearest_ennemy = null

	velocity = Input.get_vector("left","right","up","down") * movement_speed
	motion = motion.move_toward(velocity, acceleration * delta)
	
	move_and_collide(motion * delta)
	check_XP()
	health += recovery * delta

func take_damage(amount):
	health -= max(amount - armor, 1) # addiditve armor
#	health -= max(amount * (amount/(amount + armor)), 1) # multiplicative armour

func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_timer_timeout():
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth
	
func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1
	%LevelXP.text = str(XP) + "/" + str(%XP.max_value)

func _on_magnet_area_entered(area):
	if area.has_method("follow"):
		area.follow(self)

func gain_gold(amount):
	gold += amount

func open_chest():
	$UI/Chest.open()
