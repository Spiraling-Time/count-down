extends Node2D

const BACK_SCALE = 2.0

const STARTING_NUMBERS: Array = [
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,]

@onready var background2 = $Background2
@onready var aaa = $"Background2/Overcomplicated Effect"

@onready var gridNode = $Grid

@onready var PlayerHealth = $UI/PlayerHealth
@onready var OpponentHealth = $UI/OpponentHealth
var PHP
var OHP
@onready var Count = $UI/Count
@onready var Countdown = $UI/Countdown
@onready var UI = $UI

var number = preload("res://Scenes/number_1.tscn")
var player_damage = preload("res://Scenes/player_damage.tscn")

var grid_width: int = 9
var grid_height: int = 5
var grid: Array[Array] = []

var player_position: Vector2

var highlighted: Array = []

var highlighting: bool = false

var attacked: bool = false

func _ready() -> void:
	randomize()
	player_position = Vector2(4,2)
	
	PlayerHealth.visible = true
	OpponentHealth.visible = true
	
	PHP = 50
	PlayerHealth.text = str(PHP)
	OHP = 60
	OpponentHealth.text = str(OHP)
	
	await create_grid()
	

	



func _process(delta: float) -> void:
	aaa.rotation_degrees += 0.02
	var size = BACK_SCALE + (sin(aaa.rotation_degrees)/1.5)
	background2.scale = Vector2(size,size)
	Countdown.text = str(int(Count.time_left))

func _physics_process(delta: float) -> void:
	var prev_pos = player_position
	var direction: Vector2= Vector2.ZERO
	if Input.is_action_just_pressed("up"):
		direction.y = -1
	elif Input.is_action_just_pressed("down"):
		direction.y = 1
	if Input.is_action_just_pressed("left"):
		direction.x = -1
	elif Input.is_action_just_pressed("right"):
		direction.x = 1
	player_position += direction
	if player_position.x < 0: player_position.x = 0
	elif player_position.x >= grid_width: player_position.x = grid_width-1
	if player_position.y < 0: player_position.y = 0
	elif player_position.y >= grid_height: player_position.y = grid_height-1
	var same: bool = false
	if highlighted.find(player_position) != -1:
		player_position = prev_pos
		same = true
	

	
	
	if Input.is_action_just_pressed("select") and !attacked:
		if !same:
			highlighted.append(player_position)
			if highlighting:
				#print(player_position, " ", highlighted.get(highlighted.size()-2))
				var dif = (player_position-highlighted.get(highlighted.size()-2)).abs()
				if dif.x > 1.0 or dif.y > 1.0:
					print("wounded, do nothing")
					damage_you_and_opponent(1,0)
					highlighting = false
					highlighted = []
			else: highlighting = true
	elif highlighting:
		if highlighted.size()>  0:
			if grid[highlighted[0].x][highlighted[0].y] == 1:
				print("wounded, do nothing")
				damage_you_and_opponent(1,0)
				highlighting = false
			elif highlighted.size() > 1:
				#print(highlighted.size())
				var base_damage = grid[highlighted[0].x][highlighted[0].y]
				var highest = base_damage
				var count = 0
				for nums in highlighted:
					count += 1
					#print("highest: ", highest)
					#print("grid: ", grid[nums.x][nums.y])
					if grid[nums.x][nums.y] == highest:
						highest = grid[nums.x][nums.y] - 1
						if highest == 0:
							if count == highlighted.size():
								var final_damage = base_damage
								if base_damage > 3: final_damage *= 2
								print("wounded, attack for: ", final_damage) #maybe double if > than 3
								damage_you_and_opponent(1, base_damage)
								highlighting = false
								highlighted = []
								attacked = true
								#Count.stop()
								#Count.timeout.emit()
								break
							else:
								print("wounded, do nothing")
								damage_you_and_opponent(1,0)
								highlighting = false
								break
					else:
						print("wounded, do nothing")
						damage_you_and_opponent(1,0)
						highlighting = false
						break
		
		if !highlighting: highlighted = []
	
	
	for numbers in gridNode.get_children():
		if highlighted.find(numbers.coordinates) != -1:
			if numbers.coordinates == player_position:
				numbers.scale = Vector2(1.1,1.1)
				numbers.z_index = -1
				numbers.get_node("Sprite2D").z_index = -5
			else:
				numbers.scale = Vector2(1.1,1.1)
				numbers.z_index = -2
				numbers.get_node("Sprite2D").z_index = -6
			numbers.modulate = Color.RED
		elif numbers.coordinates == player_position:
			numbers.scale = Vector2(1.1,1.1)
			numbers.z_index = -1
			numbers.get_node("Sprite2D").z_index = -5
			if !attacked: numbers.modulate = Color.WEB_MAROON
			else: numbers.modulate = Color(0.132, 0.0, 0.0, 1.0)
		else:
			numbers.scale = Vector2(1.0,1.0)
			numbers.z_index = 0
			numbers.get_node("Sprite2D").z_index = -4
			numbers.modulate = Color.WHITE


func create_grid():
	grid.clear()
	var everything = STARTING_NUMBERS.duplicate()
	for x in grid_width:
		var column: Array = []
		for y in grid_height:
			column.append(everything.pop_at(randi() % everything.size()))
		grid.append(column)
	grid[4][2] = 1
	for x in grid_width:
		for y in grid_height:
			var new_number = number.instantiate()
			new_number.get_node("Number").text = str(grid[x][y])
			new_number.coordinates = Vector2(x,y)
			new_number.position = Vector2((x*50)-((grid_width * 50)/2)+50, (y*50)-((grid_height * 50)/2))
			gridNode.add_child(new_number)
	Count.start()

func damage_you_and_opponent(you, opponent):
	if opponent<= 3: OHP -= opponent
	else: OHP -= opponent*2
	OpponentHealth.text = str(OHP)
	if opponent > 0: opponent_damage_visual(opponent)
	if OHP <= 0:
		OHP = 0
		print("OPPONENT DEFEATED")
		OpponentHealth.visible = false
	else:
		PHP -= you
		PlayerHealth.text = str(PHP)
		if you > 0: your_damage_visual(you)
		if PHP <= 0:
			PHP = 0
			print("PLAYER DEFEATED")
			PlayerHealth.visible = false

func your_damage_visual(damage):
	var new_damage = player_damage.instantiate()
	new_damage.damage = damage
	new_damage.player = true
	UI.add_child(new_damage)
func opponent_damage_visual(damage):
	var new_damage = player_damage.instantiate()
	new_damage.damage = damage
	new_damage.player = false
	UI.add_child(new_damage)


func _on_count_timeout() -> void:
	attacked = false
	damage_you_and_opponent(1, 0)
	print("wounded, do nothing")
	
	
	highlighted = []
	highlighting = false
	for numbers in gridNode.get_children():
		gridNode.remove_child(numbers)
		numbers.queue_free()
	create_grid()
