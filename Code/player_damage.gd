extends Label

var damage
var player: bool

func _ready() -> void:
	modulate = Color.RED
	if player:
		text = "-"+str(damage)
		position = Vector2(-635.0, -352.0)		
		
		var tween_speed = 0.2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(-635, -352)+Vector2(randi_range(-40,35),randi_range(-40,-60)), tween_speed)
		
		await tween.finished
		
		queue_free()   
	else:
		if damage <= 3: text = "-"+str(damage)
		else:
			modulate = Color.ORANGE
			text = "-"+str(damage*2)
		position = Vector2(635.0, -352.0)
		
		var tween_speed = 0.2
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(635, -352)+Vector2(randi_range(-40,35),randi_range(-40,-60)), tween_speed)
		
		await tween.finished
		
		queue_free()   
