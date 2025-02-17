extends Node2D

var curSelected = 0

func _ready():
	$Misc/Transition._fade_out()
	
	var option_i = 0
	for option in OptionsMenuShit.cur_options:
		if option[3] == "bool":
			var checkbox = $CheckboxTemplate.duplicate()
			checkbox.checked = Options.get_data(option[1])
			checkbox.get_node("Text").text = option[0]
			checkbox.global_position.x = (20 * option_i)
			checkbox.global_position.y = 350 + (160 * option_i)
			checkbox.refresh()
			checkbox.visible = true
			$Options.add_child(checkbox)
		else:
			var value = $ValueTemplate.duplicate()
			value.type = option[3]
			value.value = option[1]
			value.title = option[0]
			
			if option[3] == "float":
				value.decimal_shit = int(option[6])
			else:
				value.decimal_shit = 1
				
			value.visible = true
			value.global_position.x = (20 * option_i)
			value.global_position.y = 350 + (160 * option_i)
			$Options.add_child(value)
			
		option_i += 1
		
	change_selection(0)
	
var hold_time = 0.0

func _process(delta):		
	if Input.is_action_just_pressed("ui_back"):
		$Misc/Transition.transition_to_scene("Options/OptionsMenu")
		
	if Input.is_action_just_pressed("ui_up"):
		change_selection(-1)
		
	if Input.is_action_just_pressed("ui_down"):
		change_selection(1)
		
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		hold_time += delta

		if hold_time > 0.5 or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			var option = OptionsMenuShit.cur_options[curSelected]
			
			match(option[3]):
				"float", "int":
					#option[4] = multiplier
					var mult = option[4]
					
					if option[3] == "int":
						mult = floor(mult)
						
					if Input.is_action_pressed("ui_left"):
						mult = mult * -1
						
					var value = Options.get_data(option[1]) + mult
					if value < option[5][0]:
						value = option[5][0]
					if value > option[5][1]:
						value = option[5][1]
					
					Options.set_data(option[1], value)
				"string":
					var array:Array = option[4]
					var str_num = array.find(Options.get_data(option[1]))
					
					print("STR NUM" + str(str_num))
					var mult = 1
						
					if Input.is_action_pressed("ui_left"):
						mult = mult * -1
						
					str_num += mult
					if str_num < 0:
						str_num = len(array) - 1
					if str_num > len(array) - 1:
						str_num = 0
						
					Options.set_data(option[1], array[str_num])
						
	else:
		hold_time = 0
			
	if Input.is_action_just_pressed("ui_accept"):
		var option = OptionsMenuShit.cur_options[curSelected]
		
		if option[3] == "bool":
			Options.set_data(option[1], !Options.get_data(option[1]))
			$Options.get_children()[curSelected].checked = Options.get_data(option[1])
			# toggles option on/off
		
func change_selection(amount):
	AudioHandler.play_audio("scrollMenu")
	
	curSelected += amount
	if curSelected < 0:
		curSelected = $Options.get_child_count() - 1
	if curSelected > $Options.get_child_count() - 1:
		curSelected = 0
		
	for song in $Options.get_children():
		song.modulate.a = 0.6
		
	$Options.get_children()[curSelected].modulate.a = 1
		
	$Cam.global_position.x = $Options.get_children()[curSelected].global_position.x - 140
	$Cam.global_position.y = $Options.get_children()[curSelected].global_position.y - 370
