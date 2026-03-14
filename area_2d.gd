extends Area2D

@export var sign_text: String = "Climb Up, And dont fall"

var player_over_sign = false
var i_visible = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_over_sign:
		if Input.is_action_just_pressed("interact") and not i_visible:
			$Instructions.visible = true
		elif Input.is_action_just_pressed("interact") and i_visible:
			$Instructions.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_over_sign = true
	


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_over_sign = false
		$Instructions.hide()
