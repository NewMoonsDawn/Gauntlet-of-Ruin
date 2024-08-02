extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print_debug(body.name)
		self.hide()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		self.show()
