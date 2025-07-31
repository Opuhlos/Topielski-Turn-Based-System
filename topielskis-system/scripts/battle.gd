extends Control

signal textbox_closed

func _ready() -> void:
	$ActionsPanel.hide()
	$Textbox.hide()
	
	# Connect the run button pressed signal to code here that handles its functionality
	$ActionsPanel/MarginContainer/Actions/RunButton.pressed.connect(_on_pressed_run_button)
	
	display_text("A foe blocks your path!")
	# An alternative way that still functions
	# await Signal(self, "textbox_closed" )
	await textbox_closed 
	$ActionsPanel.show()

func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		textbox_closed.emit()

func display_text(text: String) -> void:
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Panel/MarginContainer/Text.text = text

func _on_pressed_run_button() -> void:
	display_text("You escaped!")
	await textbox_closed
	get_tree().quit()
