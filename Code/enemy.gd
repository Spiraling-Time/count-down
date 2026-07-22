extends CharacterBody2D





func _on_weapon_body_entered(body: Node2D) -> void:
	if body.has_method("die"): body.die()
