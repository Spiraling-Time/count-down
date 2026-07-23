extends Node2D

const SPAWN_DISTANCE = 1000.0

@onready var MobSpawner = $MobSpawner
@onready var Enemy = $Enemy
@onready var Closest = $Closest


var current_active_mob

var number_of_mobs = 0
var Mob = preload("res://Scenes/mob.tscn")

var side = 1

func _ready() -> void:
	randomize()
	Closest.visible = false

func _process(delta: float) -> void:
	if number_of_mobs == 0: Closest.visible = false
	if Input.is_action_just_pressed("spawn"):
		spawn_mob()
	await check_closest()
	
func spawn_mob():
	if number_of_mobs < 2:
		Closest.visible = true
		var new_mob = Mob.instantiate()
		new_mob.position = Vector2((side*SPAWN_DISTANCE)+randi_range(-100,100), 244.0)
		side = -side
		MobSpawner.add_child(new_mob)
		number_of_mobs += 1

func check_closest():
	var dist = 100000
	if MobSpawner.get_children().size() > 0:
		for mobs in MobSpawner.get_children():
			#print(mobs)
			if mobs.position.distance_to(Enemy.position) < dist:
				dist = mobs.position.distance_to(Enemy.position)
				current_active_mob = str(mobs.name)
				#print(current_active_mob)
		Closest.position = MobSpawner.get_node(current_active_mob).position
