# start ByDesign
extends Control
class_name Email

@export_group("Nodes")
@export var flavor_text : Label

# start Psudeo Pakman
@export var expanded_email_text: Label
# end Psuedo Pakman

@export var upload_button : Button
@export var upload_bar : ProgressBar
@export var base_read_button : Button
@export var email_generator : Node

@export_group("Data")
@export_enum("Normal", "Accept", "Decline", "Spam", "Upload", "Attachment") var type : String

@export_group("Button Groups") # the node2ds are used to hide and show different groups
@export var decision_stuff : Control
@export var email_stuff : Control
@export var upload_stuff : Control
@export var all : Control

var open := false # tells the manager that it shouldnt be accounted for

var deleted : bool = false

var progress := 0.0

var base_scale := Vector2.ONE # for easy scale animation tweaks

func _ready():
	base_scale = scale
	all.visible = false
	expanded_email_text.visible = false
	
	var random : float = randf_range(70, 100)
	if random < 70:
		type = "Normal"
		
	else:
		var special_random : int = randi_range(1, 1)
		
		if special_random == 1:
			type = "Accept"
		
		elif special_random == 2:
			type = "Decline"
		
		elif special_random == 3:
			type = "Spam"
		
		elif special_random == 4:
			type = "Upload"
	
	await get_tree().process_frame
	var text = email_generator.construct_email(type) # creates the email, and sets text to an array. first value is the person and topic, second is the expanded text
	flavor_text.text = text[0]
	expanded_email_text.text = text[1]

func _process(delta):
	if Global.email_open and not open: # fixes the bug where you couldn't finish the email
		base_read_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		base_read_button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if not open:
		if abs(get_global_mouse_position().y - global_position.y) <= 25 and abs(get_global_mouse_position().x - global_position.x) < 600: # really long way to ask if the mouse is hovering over the email :P
			scale += (base_scale * 1.05 - scale) / 5 # little popup animation when hovering
		else:
			scale += (base_scale - scale) / 5

func delete_email(input : String): # delete email after doing little animation
	expanded_email_text.visible = false
	all.visible = false
	Global.email_open = false # used to tell other emails to work again
	open = false
	
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(800, 50), 0.1) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(350, 24), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 30), 0.2) # stop ellipses from appearing
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(0, 0), 0.2) # move buttons to original place
	
	await move_buttons_tween.finished
	
	deleted = true # let the manager know that it shouldnt account for this email anymore
	z_index = -1 # get it out of the way to avoid overlap
	var slide_out = create_tween().tween_property(self, "position", Vector2(-2000.0, position.y), 0.5)
	await slide_out.finished
	
	if type == "Normal":
		if input == "Upload":
			pass # add boss
		if input == "Accept" || input == "Decline":
			Global.manager.add_more_emails(1)
	
	if type == "Accept":
		if input == "Accept":
			pass # give upgrade
	
	if type == "Decline":
		if input == "Upload":
			Global.manager.add_more_emails(1)
		if input == "Accept":
			Global.manager.add_more_emails(3)
		
		if input == "Normal" || input == "Spam":
			pass # add boss
	
	if type == "Spam":
		if input == "Upload":
			pass # add popups
		if input == "Accept" || input == "Decline":
			Global.manager.add_more_emails(5)
		
		if input == "Normal":
			Global.manager.add_more_emails(1)
	
	if type == "Upload":
		if input == "Spam":
			pass # add boss
		if input == "Accept" || input == "Decline":
			pass # add boss
		if input == "Normal":
			Global.manager.add_more_emails(3)
	
	queue_free()

func open_email(type):
	Global.email_open = true # used to tell other emails not to open
	open = true
	base_read_button.visible = false # hide the regular read button used to open the email
	all.visible = true # show the correct buttons for the email type, hidden earlier in the script
	expanded_email_text.visible = true
	
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(800, 600), 0.2) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(350, 400), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 400), 0.2) # stop ellipses from appearing
	var move_tween = create_tween().tween_property(self, "position", Vector2(0, 0), 0.2) # move box to right position
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(-30, 480), 0.2) # move buttons to bottom
	z_index = 5
	# start Psuedo Pakman
	expanded_email_text.visible = true
	# end Psuedo Pakman


# special interaction stuff
func _on_read_pressed():
	if open:
		delete_email("Normal")
	elif not Global.email_open:
		open_email(type)

func _on_yes_pressed():
	if open:
		delete_email("Accept")
	elif not Global.email_open:
		open_email(type)

func _on_no_pressed():
	if open:
		delete_email("Decline")
	elif not Global.email_open:
		open_email(type)

func _on_delete_pressed():
	if open:
		delete_email("Spam")
	elif not Global.email_open:
		open_email(type)

func _on_upload_pressed(): # i think i did this one wrong (?)
	if open:
		while upload_button.button_pressed:
			await get_tree().physics_frame
			if [true, false].pick_random():
				progress += 1
			upload_bar.value = progress
		
		if progress >= 100:
			delete_email("Upload")
		else:
			if not upload_button.button_pressed:
				progress = 0
				upload_bar.value = progress
	
	elif not Global.email_open:
		open_email(type)
# end ByDesign
