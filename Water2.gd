extends CharacterBody2D

var speed = 235
var facing = "Right"
var fall = 100


func _physics_process(delta):
	if facing == "Right":
		position += transform.x * speed * delta
		get_node("AnimatedSprite2D").flip_h = false
	else:
		position -= transform.x * speed * delta
		get_node("AnimatedSprite2D").flip_h = true
	position += transform.y * fall * delta
# Called when the node enters the scene tree for the first time.



func _on_body_entered(body):
	print_debug("Water touched " + body.name)
	if body.is_in_group("Mobs"):
				body.velocity = transform.x * speed * 2
	if not body.name =="Player": #or not body.is_in_group("Tilemaps"):
		queue_free()
	if body.is_in_group("Fire"):
		print_debug("Extinguish?")
		body.queue_free()

