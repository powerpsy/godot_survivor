extends PanelContainer

@export var weapon : Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown

func _on_cooldown_timeout():
	if weapon:
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_ennemy, get_tree())
