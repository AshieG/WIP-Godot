extends KinematicBody2D

const SPEED = 350
const GRAVITY = 12
const JUMP_POWER = -360 
const FLOOR = Vector2(0,-1)
const MAX_FALL_SPEED = 250
const CLIMBING_SPEED = 300


var climbing = false
var attacking = false
var attack_animation = null
var animation_number = 1


var velocity = Vector2()

var on_ground = false

var jump_count = 0
var MAX_JUMP_COUNT = 1


func _physics_process(delta):
	
	
	
	attack_animation = "attack"+str(animation_number)
	print(animation_number)
	
	if attacking == false:
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = true 
		else:
			velocity.x = 0
			if on_ground == true:
				$AnimatedSprite.play("idle")

					
		if Input.is_action_pressed("ui_up"):
			if on_ground == true:
				velocity.y = JUMP_POWER
				on_ground = false
			if jump_count < MAX_JUMP_COUNT and Input.is_action_just_pressed("ui_up"):
				velocity.y = JUMP_POWER
				jump_count += 1
		
		if Input.is_action_pressed("ui_down"):
			if on_ground == true:
				velocity.x = 0
				$AnimatedSprite.play("crouch")
			
			
			
		if Input. is_action_just_pressed("ui_accept"):
			$Timer.start()
			attack()
			
			if $Timer.time_left > 0:
				animation_number += 1
				
			if animation_number == 4:
				animation_number = 1
				
		
				
		velocity.y += GRAVITY 
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED
				
		if is_on_floor():
			on_ground = true
			jump_count = 0 
		else:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
		
			
					
		velocity = move_and_slide(velocity, FLOOR)
	
	
	
func attack():
	attacking = true
	velocity.x = 0
	$AnimatedSprite.play(attack_animation)
	if $AnimatedSprite.flip_h == false:
		self.position += Vector2(8,0)
	else:
		self.position -= Vector2(8,0)
	yield($AnimatedSprite, "animation_finished")
	attacking = false
	

	
	
	
	

func _on_Timer_timeout():
	animation_number = 1


