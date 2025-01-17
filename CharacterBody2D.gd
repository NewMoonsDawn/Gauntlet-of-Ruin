extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false


func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	player = get_node("../../Player/Player")
	var direction = (player.position - self.position).normalized()
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		if direction.x > 0:
			velocity.x = direction.x * SPEED
			get_node("AnimatedSprite2D").flip_h = true
		else:
			velocity.x = direction.x * SPEED
			get_node("AnimatedSprite2D").flip_h = false
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = 0

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true



func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_damage_body_entered(body):
	if body.name == "Player":
		body.health -=3
		death()
		
func death():
	chase = false
	velocity.x = 0
	get_node("AnimatedSprite2D").play("Death")
	if get_node_or_null("PlayerDamage") != null:
		get_node("PlayerDamage").queue_free()
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
