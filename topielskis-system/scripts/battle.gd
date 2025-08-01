extends Control

signal textbox_closed

@export var enemy: BaseEnemy

func _ready() -> void:
	set_health($PlayerPanel/MarginContainer/PlayerData/PlayerHealthBar, 50, 50)
	
	set_health($EnemyContainer/EnemyHealthBar, enemy.health, enemy.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	
	$ActionsPanel.hide()
	$Textbox.hide()
	
	# Connect the run button pressed signal to code here that handles its functionality
	$ActionsPanel/MarginContainer/Actions/RunButton.pressed.connect(_on_pressed_run_button)
	
	display_text("A %s blocks your path!" % [enemy.name])
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

func set_health(progress_bar: ProgressBar, health: int, max_health: int) -> void:
	progress_bar.max_value = max_health
	progress_bar.value = health
	
	var label: Label = progress_bar.get_node("Label")
	label.text = "HP %s/%s" % [health, max_health]
