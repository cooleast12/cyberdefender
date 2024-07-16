extends CharacterBody2D

var SPEED = 500
var vel : float
	
func _physics_process(delta):
	move_local_x(vel * SPEED * delta)
	move_and_slide()



func _on_area_2d_body_entered(body):
	queue_free()
