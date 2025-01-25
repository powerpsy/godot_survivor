extends Control

func _ready():
	menu()

func _on_upgrades_pressed():
	skill_tree()

func _on_bestiary_pressed():
	bestiary()

func _on_back_pressed():
	menu()

func menu():
	$Menu.show()
	$SkillTree.hide()
	$Bestiary.hide()
	$Gold.hide()
	$Back.hide()
	tween_pop($Menu)
	
func skill_tree():
	$Menu.hide()
	$SkillTree.show()
	$Gold.show()
	$Back.show()
	tween_pop($SkillTree)

func bestiary():
	$Menu.hide()
	$Bestiary.show()
	$Gold.hide()
	$Back.show()
	tween_pop($Bestiary)

func tween_pop(panel):
	SoundManager.play_sfx(load("res://Resources/UI/Swipe panel.wav"))
	panel.scale = Vector2(0.9,0.9)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(panel, "scale", Vector2(1,1), 0.5)
