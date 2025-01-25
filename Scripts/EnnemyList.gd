extends VBoxContainer

const path = "res://Resources/Ennemies/"

var ennemies = []

func _ready():
	dir_contents()

func dir_contents():
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
#			print("Found file: "+ file_name)
			
			var ennemy_resource : Ennemy = load(path + file_name)
			ennemies.append(ennemy_resource)

			var button = Button.new()
			button.pressed.connect(_on_pressed.bind(button))
			button.text = ennemy_resource.title
			add_child(button)
			
			file_name = dir.get_next()
	else:
		print("No files in ennemies folder")
#	print(ennemies)

func _on_pressed(button: Button):
	var index = button.get_index()
	%Name.text = "Name: " + ennemies[index].title
	%Health.text = "Health: " + str(ennemies[index].health)
	%Damage.text = "Damage: " + str(ennemies[index].damage)
	%Texture.texture = ennemies[index].texture
	SoundManager.play_sfx(load("res://Resources/UI/Cursor 1.wav"))
