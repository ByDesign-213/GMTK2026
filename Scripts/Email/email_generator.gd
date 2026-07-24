# start ByDesign
@tool
extends Node

# making the in editor stuff work
@export_tool_button("Refresh Variables") var refresh_variables = func update_vars(): notify_property_list_changed()

@export_group("People")
@export var people : Array[String]

@export_group("Groups")
@export var groups : Array[String]
var people_groups : Dictionary = {}
var group_topics : Dictionary = {}
var topic_extended : Dictionary = {}

# email visual
# people are in groups
# certain groups can send certain topics
# those topics have multiple expandeds

func _get_property_list():
	var properties: Array[Dictionary] = []
	
	properties.append({
		"name": "People",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	for person in people:
		properties.append({
			"name": person + " : Person",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": str(groups).replace('"', '').replace('[', '').replace(']', '') # remove the array format for looks
		})
	
	properties.append({
		"name": "Topics",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	for group in groups:
		properties.append({
			"name": group + " : Topics",
			"type": TYPE_PACKED_STRING_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			"hint_string": ""
		})
	
	properties.append({
		"name": "Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	for topic in group_topics:
		properties.append({
			"name": topic + " Topics : Extended",
			"type": TYPE_PACKED_STRING_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			"hint_string": ""
		})
	
	#for group in groups:
		#properties.append({
			#"name": group + " : Group",
			#"type": TYPE_PACKED_STRING_ARRAY,
			#"usage": PROPERTY_USAGE_DEFAULT,
			#"hint": PROPERTY_HINT_NONE,
			#"hint_string": ""
		#})
	
	return properties

# changing this function may result in Godot crashing, and my script breaking, as this runs even while in the editor. you have been warned
func _get(property):
	if property.contains(" : Person"):
		property = property.rstrip(" : Person")
		return people_groups[property]
	
	if property.contains(" : Topics"):
		property = property.rstrip(" : Topics")
		return group_topics[property]
	
	if property.contains(" : Extended"):
		property = property.rstrip(" : Extended")
		return topic_extended[property]
	
	return null

# changing this function may result in Godot crashing, and my script breaking, as this runs even while in the editor. you have been warned
func _set(property, value):
	if property.contains(" : Person"):
		property = property.rstrip(" : Person")
		people_groups[property] = value
		return true
	
	if property.contains(" : Topics"):
		property = property.rstrip(" : Topics")
		group_topics[property] = value
		return true
	
	if property.contains(" : Extended"):
		property = property.rstrip(" : Extended")
		topic_extended[property] = value
		return true
	
	return false


## creating the email
#func create_email(type):
	#var sender = choose_sender(type)
	#var topic = choose_topic(type)
	#var text = choose_expanded_text(topic)
	#
	#return [sender + " - " + topic, text]
#
#func choose_sender(type):
	#if type == "Normal":
		#return read_people.pick_random()
	#if type == "Accept":
		#return accept_people.pick_random()
	#if type == "Decline":
		#return decline_people.pick_random()
	#if type == "Spam":
		#return spam_people.pick_random()
	#if type == "Upload":
		#return upload_people.pick_random()
#
#func choose_topic(type):
	#if type == "Normal":
		#return read_topics.pick_random()
	#if type == "Accept":
		#return accept_topics.pick_random()
	#if type == "Decline":
		#return decline_topics.pick_random()
	#if type == "Spam":
		#return spam_topics.pick_random()
	#if type == "Upload":
		#return upload_topics.pick_random()
#
#func choose_expanded_text(topic):
	#return get(topic)[randi_range(0, get(topic).size() - 1)] # .pick_random doesnt work for packed string arrays
## end ByDesign
