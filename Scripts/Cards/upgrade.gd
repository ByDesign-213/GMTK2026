# start Psuedo Pakman
extends Button
class_name BaseUpgrade

@export_group("Display")
@export var display_name: String:
	set(name):
		display_name = name
		%UpgradeName.text = display_name
@export var display_desc: String:
	set(desc):
		display_desc = desc
		%UpgradeDescription.text = display_desc
@export var display_image: Texture:
	set(image):
		display_image = image
		%UpgradeTexture.texture = display_image

var effects: Dictionary[UpgradeType, float]

@export var upgrade_list: Array[UpgradeItem]

enum UpgradeType {
	UPLOAD_SPEED,
	VIRUS_CHANCE,
	SPAM_CHANCE,
	EMAIL_SPEED
}

func _ready() -> void:
	connect("pressed", pressed)
	random_card()

func pressed() -> void:
	pass
# end Psuedo Pakman

func random_card() -> void:
	# Pick a random upgrade from predefined list.
	var random_upgrade = upgrade_list.pick_random()
	print("picking random upgrade:" + str(random_upgrade))
	
	display_name = random_upgrade.name
	display_desc = random_upgrade.desc
	effects = random_upgrade.effects
	
	if random_upgrade != null:
		display_image = random_upgrade.image
	
	#Cycles through upgrade effects if more than one, and appends everything to description.
	for effect in random_upgrade.effects:
		match effect:
			UpgradeType.UPLOAD_SPEED:
				display_desc += "\nUpload speed "
			UpgradeType.VIRUS_CHANCE:
				display_desc += "\nVirus chance "
			UpgradeType.SPAM_CHANCE:
				display_desc += "\nSpam chance "
		# Adds a plus if a positive number.
		if random_upgrade.effects[effect] > 0:
			display_desc += " + "
		display_desc += str(int(random_upgrade.effects[effect]))
