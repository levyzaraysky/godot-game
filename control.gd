extends Control

@onready var start = $ColorRect/VBoxContainer/StartButton
@onready var quit = $ColorRect/VBoxContainer/QuitButton
@onready var animations = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	animations.play("global/fade_in")
	await animations.animation_finished
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
