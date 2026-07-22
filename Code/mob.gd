extends CharacterBody2D

const SPEED = 150
const DASH_SPEED = SPEED*30

var main
@onready var Enemy = $"../../Enemy"
@onready var collider = $Area2D

var target

func _ready() -> void:
	main = get_tree().current_scene
	target = (Enemy.position-position).normalized()
	#print(target.x)
	collider.position.x = target.x*25.0

func _physics_process(delta: float) -> void:	
	#if !position.distance_to(Enemy.position) <= SPEED/2.0:
	target = (Enemy.position-position).normalized()
	velocity = SPEED*target
	collider.position.x = target.x*25.0
	
	#else: velocity = Vector2.ZERO
	
	if main.current_active_mob == str(name):
		if Input.is_action_just_pressed("right"):
			velocity.x = DASH_SPEED
		elif Input.is_action_just_pressed("left"):
			velocity.x = -DASH_SPEED

	move_and_slide()
	
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
