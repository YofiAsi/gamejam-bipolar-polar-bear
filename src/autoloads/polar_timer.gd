extends Timer

var first_big_timeout: bool = true

func _on_timeout() -> void:
	if Global.player.curr_state == Global.State.SMALL:
		if first_big_timeout:
			first_big_timeout = false
			self.start(5)
		else:
			self.start(randi_range(8, 18))
	else:
		self.start(randi_range(3, 7))
