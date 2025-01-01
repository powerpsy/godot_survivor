extends Pickups
class_name Rosary

func activate():
	super.activate()
	player_reference.get_tree().call_group("Ennemy", "drop_item")
