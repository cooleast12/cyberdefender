extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const DASH = 1000
var dash_is_ready: bool = true
var dashing: bool = false
var dashDirection = Vector2(1, 0)


func _physics_process(delta):
	if not is_on_floor() and !dashing:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 2


	var direction = Input.get_axis("move_left", "move_right")
	if direction and !dashing:
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
		
	if Input.is_action_just_pressed("dash") and dash_is_ready:
		if $AnimatedSprite2D.flip_h: 
			dashDirection = Vector2(-1, 0)
		if !$AnimatedSprite2D.flip_h:
			dashDirection = Vector2(1, 0)
			
		velocity = dashDirection.normalized() * DASH
		dash_is_ready = false
		dashing = true
		await get_tree().create_timer(0.2).timeout
		dashing = false
		$DashCoolDown.start()
	
	move_and_slide()


	

func _on_timer_timeout():
	dash_is_ready = true # Replace with function body.
