extends NinePatchRect

@onready var chest = $AnimatedSprite2D
@onready var options = %Options
@onready var rewards = $Rewards
@onready var sound : AudioStream

func _ready():
	randomize()
	hide()
	$Open.show()
	$Close.hide()

func open():
	clear_reward()
	chest.play("idle_boss_chest")
	get_tree().paused = true
	show()
	$Open.show()
	$Close.hide()

func set_reward():
	clear_reward()
	var chance = randf()
	if chance < 0.6:
		upgrade_item(2,3)
	elif chance < 0.90:
		upgrade_item(1,4)
	else:
		upgrade_item(0,5)

func upgrade_item(start, end):
	for index in range(start, end):
		var upgrades = options.get_available_upgrades()
		if upgrades.size() == 0:
			add_gold(index)
		else:
			var selected_upgrade : Item
			selected_upgrade = upgrades.pick_random()
			if selected_upgrade is Weapon and selected_upgrade.max_level_reached():
				rewards.get_child(index).texture = selected_upgrade.evolution.icon
			else:
				rewards.get_child(index).texture = selected_upgrade.icon
			selected_upgrade.upgrade_item()

func clear_reward():
	for slot in rewards.get_children():
		slot.texture = null

func _on_close_pressed():
	get_tree().paused = false
	hide()

func _on_open_pressed():
	SoundManager.play_sfx(sound)
	clear_reward()
	chest.play("open_boss_chest")
	await chest.animation_finished
	set_reward()
	$Open.hide()
	$Close.show()

func add_gold(index):
	var gold : Gold = load("res://Resources/Pickups/gold.tres")
	gold.player_reference = owner
	rewards.get_child(index).texture = gold.icon
	gold.activate()
