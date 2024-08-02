extends Area2D

var speed = 235
var facing = "Right"


func _physics_process(delta):
	if facing == "Right":
		position += transform.x * speed * delta
	else:
		position -= transform.x * speed * delta
# Called when the node enters the scene tree for the first time.



func _on_body_entered(body):
	if body.is_in_group("Mobs"):
		body.death()
	if not body.name =="Player": #or not body.is_in_group("Tilemaps"):
		queue_free()
	if body.is_in_group("BreakableWalls"):
		body.queue_free()

