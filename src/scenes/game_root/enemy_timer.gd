class_name EnemyTimer extends Timer

signal spawn_timeout(enemy_type: String, amount: int)

@export var my_type: String
var spawn_count: int

func _ready() -> void:
	self.one_shot = false
	self.autostart = false
	self.timeout.connect(func (): spawn_timeout.emit(self.my_type, self.spawn_count))
