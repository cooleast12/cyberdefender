extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -320.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x<0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("default")
		if velocity.x>0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)
		$AnimatedSprite2D.play("Idle")
	
	move_and_slide()
