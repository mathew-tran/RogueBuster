extends Button

func _on_RestartButton_pressed():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	print(enemies)
	for enemy in enemies:
		print(enemy)
		enemy.queue_free()
	get_tree().reload_current_scene()

func _input(event):
	if visible:
		if event.is_action_pressed("ui_accept"):
			$AudioStreamPlayer2D.play()
			_on_RestartButton_pressed()
	
