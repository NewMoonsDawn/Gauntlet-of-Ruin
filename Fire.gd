extends CharacterBody2D



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.health -=1
	elif body.name == "Frog":
		body.death()
	print_debug(body.name)
