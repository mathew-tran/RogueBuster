extends Control

func _on_Player_XInputUpdate(maxValue, currentValue, name):
	$XAction/ActionText.text = name
	$XAction/ProgressBar.value = maxValue - currentValue
	$XAction/ProgressBar.min_value = 0
	$XAction/ProgressBar.max_value = maxValue
	if currentValue == 0.0:
		if !$XAction/XAnimationPlayer.is_playing():
			$XAction/XAnimationPlayer.play("Useable")

func _on_Player_ZInputUpdate(maxValue, currentValue, name):
	$ZAction/ActionText.text = name	
	$ZAction/ProgressBar.value = maxValue - currentValue
	$ZAction/ProgressBar.min_value = 0
	$ZAction/ProgressBar.max_value = maxValue
	if currentValue == 0.0:
		if !$ZAction/ZAnimationPlayer.is_playing():
			$ZAction/ZAnimationPlayer.play("Useable")

func _on_Player_HealthUpdate(maxValue, currentValue):
	$Health/AnimationPlayer.stop(true)
	$Health/AnimationPlayer.play("HitAnimation")
	$Health/ProgressBar.min_value = 0
	$Health/ProgressBar.max_value = maxValue
	$Health/ProgressBar.value = currentValue	
	$Health/ProgressBar/HealthText.text = str(currentValue) + "/" + str(maxValue)


