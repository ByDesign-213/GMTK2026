extends Resource
class_name UpgradeItem

@export var name: String = "Upgrade_Name"
@export var desc: String = "Upgrade_Desc"
@export var image: Texture
@export var effects: Dictionary[UpgradeType, float]

enum UpgradeType {
	UPLOAD_SPEED,
	VIRUS_CHANCE,
	SPAM_CHANCE,
	EMAIL_SPEED
}
