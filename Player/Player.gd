extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const DASH_SPEED = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 1

var jump_timer = 0

var mouse_direction

var elements = [ "Wind","Fire","Water","Earth" ]
var currentElement = 0
var canDash = false

var rock
var previousrock

var facing = "right"

var canShootFlame = true

@onready var anim = get_node("AnimationPlayer")





func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		jump_timer = 0.1
	jump_timer -= delta
	
	if jump_timer > 0 and is_on_floor():
		jump_timer = 0
		velocity.y = JUMP_VELOCITY
		canDash = true
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		facing = "Left"
	else: if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		facing = "Right"
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y ==0:
			anim.play("Run")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y ==0:
			anim.play("Idle")
		
	if velocity.y > 0:
		anim.play("Fall")
		
	if Input.is_action_just_pressed("ui_change_element_left"):
		currentElement-=1
		if currentElement == -1:
			currentElement = 3
		print(elements[currentElement])
	
	if Input.is_action_just_pressed("ui_change_element_right"):
		currentElement+=1
		if currentElement == 4:
			currentElement = 0
		print(elements[currentElement])
		
	if Input.is_action_just_pressed("ui_right_mouse_button"):
		match currentElement:
			0:
					dash()
			1:
					shootflame()
			2:
					shootWater()
			3:
					spawnRock()
			_:
				print("Mistake!")
		
	if health <= 0:
		get_tree().reload_current_scene()
		
	
	move_and_slide()


func shootflame():
	if canShootFlame == true:
		var flame = preload("res://flame.tscn").instantiate()
		flame.facing = facing
		owner.add_child(flame)
		if(facing == "Right"):
			flame.global_position = $FirepointRight.global_position
		else:
			flame.global_position = $FirepointLeft.global_position
		canShootFlame = false
	
func spawnRock():
	if canDash:
		if rock:
			previousrock = rock
		rock = preload("res://EarthSummon.tscn").instantiate()
		owner.add_child(rock)
		rock.global_position = get_global_mouse_position()
		if previousrock:
			previousrock.queue_free()
		canDash = false
		
func dash():
	if canDash:
					mouse_direction = get_local_mouse_position().normalized()
					velocity = Vector2((DASH_SPEED * mouse_direction.x)*2, DASH_SPEED * mouse_direction.y)
					canDash = false

func shootWater():
	var water = preload("res://Water.tscn").instantiate()
	water.facing = facing
	owner.add_child(water)
	if(facing == "Right"):
		water.global_position = $FirepointRight.global_position
	else:
		water.global_position = $FirepointLeft.global_position


func _on_timer_timeout():
	canShootFlame = true
