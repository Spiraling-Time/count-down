extends CharacterBody2D

const SPEED = 150
const DASH_SPEED = SPEED*30

var main
@onready var Enemy = $"../../Enemy"
@onready var collider = $Area2D

var target

var gravity = 7

func _ready() -> void:
	main = get_tree().current_scene
	target = (Enemy.position-position).normalized()
	#print(target.x)
	collider.position.x = target.x*25.0

func _physics_process(delta: float) -> void:	
	#if !position.distance_to(Enemy.position) <= SPEED/2.0:
	target = (Enemy.position-position).normalized()
	var target_x = target.x
	velocity.x = SPEED*target_x
	if Enemy.position.y-position.y > 1:
		collider.position.x = 0.0
		collider.position.y = 30.0
		collider.rotation_degrees = 90.0
	else:
		collider.position.y = 0.0
		collider.rotation_degrees = 0.0
		collider.position.x = target_x*25.0
	
	#else: velocity = Vector2.ZERO
	var jumping = false
	
	if main.current_active_mob == str(name):
		if Input.is_action_just_pressed("right"):
			velocity.x = DASH_SPEED
		elif Input.is_action_just_pressed("left"):
			velocity.x = -DASH_SPEED
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = -10000
			jumping = true
		#print(position.y)
	if !jumping:
		if is_on_floor():
			velocity.y = 0
		elif velocity.y != 50: velocity.y = 50
		else: velocity.y *= gravity
		if velocity.y > 1000: velocity.y = 1000

	move_and_slide()
	
	if collider.has_overlapping_bodies(): _on_area_2d_body_entered(collider.get_overlapping_bodies()[0])
	
func die():
	main.number_of_mobs -= 1
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("entered")
	if Input.is_action_pressed("right"):
		if Enemy.face.x == 1 or Enemy.weapon.visible == false:
			print("hit")
			position.x += 300
			target = (Enemy.position-position).normalized()
			
	elif Input.is_action_pressed("left"):
		if Enemy.face.x == -1 or Enemy.weapon.visible == false:
			print("hit")
			position.x -= 300
			target = (Enemy.position-position).normalized()
