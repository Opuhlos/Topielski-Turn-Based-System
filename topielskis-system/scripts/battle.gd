extends Control

signal textbox_closed

@export var enemy: BaseEnemy

@onready var enemy_hp_bar: ProgressBar = $EnemyContainer/EnemyHealthBar
@onready var player_hp_bar: ProgressBar = $PlayerPanel/MarginContainer/PlayerData/PlayerHealthBar

var current_player_health: int
var current_enemy_health: int

func _ready() -> void:
	set_health(player_hp_bar, State.max_health, State.max_health)
	current_player_health = State.max_health
	
	set_health(enemy_hp_bar, enemy.health, enemy.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	current_enemy_health = enemy.health
	
	$ActionsPanel.hide()
	$Textbox.hide()
	
	# Connect the run button pressed signal
	$ActionsPanel/MarginContainer/Actions/RunButton.pressed.connect(_on_pressed_run_button)
	
	# Connect the attack button pressed signal
	$ActionsPanel/MarginContainer/Actions/ActionButton.pressed.connect(_on_pressed_attack_button)
	
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

func set_health(progress_bar: ProgressBar, health: int, max_health: int) -> void:
	progress_bar.max_value = max_health
	progress_bar.value = health
	
	var label: Label = progress_bar.get_node("Label")
	label.text = "HP %s/%s" % [health, max_health]

func enemy_turn() -> void:
	await get_tree().create_timer(1).timeout
	
	display_text("The %s attacked you!" % [enemy.name])
	await textbox_closed
	
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	
	current_player_health = max(0, current_player_health - enemy.attack)
	set_health(player_hp_bar, current_player_health, State.max_health)

func _on_pressed_run_button() -> void:
	display_text("You escaped!")
	await textbox_closed
	get_tree().quit()

func _on_pressed_attack_button() -> void:
	display_text("You attacked!")
	await textbox_closed
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health(enemy_hp_bar, current_enemy_health, enemy.health)
	
	enemy_turn()
