extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var dash_cooldown_timer = $DashCooldown
@onready var dash_status = $Camera2D/DashCooldownBar

var speed = 150.0
const JUMP_VELOCITY = -400.0
const DASH_LENGTH = 5

# Begin Coords
var changes_allowed = true
var start_x
var start_y

# Dashing
var dash_length = DASH_LENGTH
var dash_cooldown = 6
var can_dash = true
var is_dashing = false

func _on_dash_cooldown_timer_timeout():
	can_dash = true
	
func start_dash():
	can_dash = false
	is_dashing = true
	for i in 10:
		position.x += dash_length
	dash_cooldown_timer.start()
	await get_tree().create_timer(0.2).timeout
	is_dashing = false
	


func _physics_process(delta: float) -> void:
	# Starting Coords
	if changes_allowed:
		start_x = position.x
		start_y = position.y
		changes_allowed = false
		
	# Reset to starting coords
	if Input.is_action_just_pressed("restart"):
		position.x = start_x
		position.y = start_y
	
	# Remove Cooldown Bar if Ready
	if can_dash == true:
		dash_status.visible = false
	else:
		dash_status.visible = true
	# Dash Reload
	if is_on_floor():
		can_dash = true
	
	# Cooldown Bar
	dash_status.value = dash_cooldown_timer.wait_time - dash_cooldown_timer.time_left
	if not _animated_sprite.is_playing():
		_animated_sprite.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Sprint
	if Input.is_action_pressed("sprint"):
		if speed < 200:
			speed += 5
	else:
		speed = 150
	
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash()
		dash_cooldown_timer.connect("timeout", Callable(self, "_on_dash_cooldown_timer_timeout"))
	
	# Sprite rotation
	if Input.is_action_just_pressed("left"):
		$AnimatedSprite2D.flip_h=true
		dash_length = -DASH_LENGTH
	elif Input.is_action_just_pressed("right"):
		$AnimatedSprite2D.flip_h=false
		dash_length = DASH_LENGTH
	
	# Runimation
	if Input.is_action_pressed("left"):
		_animated_sprite.play("run")
	
	# Movement
	if direction:
		velocity.x = direction * speed
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
