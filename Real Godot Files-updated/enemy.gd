extends CharacterBody2D

var dashing = false
@export var target_to_chase: CharacterBody2D
var health = 3
var damaged :bool = false

var speed = 50
var facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta 
	if !damaged:
		$AnimatedSprite2D.modulate = Color(1,1,1)
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.modulate = Color(1,0,0)
		$AnimatedSprite2D.play("damaged")
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	if is_on_wall() && !dashing:
		flip()
		dashing = true
		await get_tree().create_timer(2.0).timeout
		dashing = false
	velocity.x = speed
	move_and_slide()
func destroy():
	queue_free()


func _on_area_2d_body_entered(body):
	if health == 1 :
		destroy()
	health -= 1
	damaged = true
	await get_tree().create_timer(0.2).timeout
	damaged = false
