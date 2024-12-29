extends PanelContainer

@export var item : Weapon:
	set(value):
		item = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown
		item.slot = self

func _on_cooldown_timeout():
	if item:
		$Cooldown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_ennemy, get_tree())
