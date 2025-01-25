extends CharacterBody2D

@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://Scenes/Damage.tscn")
var direction : Vector2
var speed : float = 200
const knock_back = 100
var damage : float
var knockback : Vector2
var separation : float

var drop = preload("res://Scenes/Pickups.tscn")

var health : float:
	set(value):
		health = value
		if health < 0:
			drop_item()
			queue_free()

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
		health = value.health

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D,"rotation", deg_to_rad(5),randf_range(0.1, 0.5))
	tween.tween_property($Sprite2D,"rotation", deg_to_rad(-5),randf_range(0.1, 0.5))

func _physics_process(delta):
	check_separation(delta)
	knockback_update(delta)

func check_separation(delta):
	separation = (player_reference.position - position).length()
	if separation >=1500 and not elite:
		queue_free()
	if separation < player_reference.nearest_ennemy_distance:
		player_reference.nearest_ennemy = self

func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO,2)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * knock_back

func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50,-25)
	get_tree().current_scene.add_child(popup)

func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate",  Color(3,0.25,0.25), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate",  Color(1,1,1), 0.2)
	tween.bind_node(self)
	damage_popup(amount)
	health -= amount

func drop_item():
	if type.drops.size() == 0:
		return
	var item = type.drops.pick_random()
	if elite:
		item = load("res://Resources/Pickups/Chest.tres")
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	queue_free()
