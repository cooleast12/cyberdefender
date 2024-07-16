extends CharacterBody2D

@onready var increment = 0
@onready var particles = $GPUParticles2D
@onready var pixelball = preload("res://projectile.tscn")

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var jump_count = 0

var is_attacking = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const DASH = 800
var dash_is_ready: bool = true
var dashing: bool = false
var dashDirection = Vector2(1, 0)



func _physics_process(delta):
	if not is_on_floor() and !dashing:
		velocity.y += gravity * delta
	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_count = jump_count + 1
		
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 2
	
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_count < 2:
		velocity.y = JUMP_VELOCITY
		jump_count = jump_count + 1
		
	if Input.is_action_just_pressed("Throw"):
		is_attacking = true
		$AnimatedSprite2D.play("throw")
		if $AnimatedSprite2D.flip_h:
			var k = pixelball.instantiate()
			k.vel = scale.x * -1
			get_parent().add_child(k)
			k.position = $ShotPosLeft.global_position
		else:
			var k = pixelball.instantiate()
			k.vel = scale.x
			get_parent().add_child(k)
			k.position = $ShotPos.global_position
		

	if is_attacking:
		$AnimatedSprite2D.play("throw")
		await $AnimatedSprite2D.animation_finished
		is_attacking = false
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction and !dashing:
			velocity.x = direction * SPEED
			if velocity.x<0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("walk")
			if velocity.x>0:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("walk")
		else:
				velocity.x = move_toward(velocity.x, 0, SPEED / 2)
				$AnimatedSprite2D.play("idle")
	
	if jump_count >= 1:
		if $AnimatedSprite2D.flip_h: 
			$AnimatedSprite2D.play("jump")
		if !$AnimatedSprite2D.flip_h: 
			$AnimatedSprite2D.play("jump")
		
	if Input.is_action_just_pressed("dash") and dash_is_ready:
		if $AnimatedSprite2D.flip_h:
			dashing = true
			dashDirection = Vector2(-1, 0)
		if !$AnimatedSprite2D.flip_h:
			dashing = true
			dashDirection = Vector2(1, 0)
		
		particles.emitting = true
		velocity = dashDirection.normalized() * DASH
		dash_is_ready = false
		await get_tree().create_timer(0.2).timeout
		dashing = false
		particles.emitting = false
		$DashCoolDown.start()
	
	move_and_slide()
	
func _on_timer_timeout(): 
	dash_is_ready = true

func _on_area_2d_body_entered(body):
	queue_free()
	var current_scene_file = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_file)


