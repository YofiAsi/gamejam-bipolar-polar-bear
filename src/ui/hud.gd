class_name GameHUD extends CanvasLayer

@onready var hp_progress_bar: ProgressBar = $VBoxContainer/HP/ProgressBar
@onready var xp_progress_bar: ProgressBar = $VBoxContainer/XP/ProgressBar
@onready var hp_label: Label = $VBoxContainer/HP/Label
@onready var armor_label: Label = $VBoxContainer/ARMOR/Label
@onready var polar_progress_bar: ProgressBar = $VBoxContainer2/PolarProg
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var max_hp: int:
	set(value):
		hp_progress_bar.max_value = value
		max_hp = value

var curr_hp: int:
	set(value):
		curr_hp = value
		hp_label.text = str(int(self.curr_hp * 100.0 / self.max_hp))

var max_polar_prog: int:
	set(value):
		polar_progress_bar.max_value = value
		max_polar_prog = value

var curr_polar_prog: int:
	set(value):
		curr_polar_prog = value
		polar_progress_bar.value = value

var max_xp: int:
	set(value):
		xp_progress_bar.max_value = value
		max_xp = value

var curr_xp: int = 0:
	set(value):
		curr_xp = value
		#xp_progress_bar.value = value

const BAR_SPEED: float = 10.

func _ready() -> void:
	Global.xp_changed.connect(self._on_player_xp_changed)
	
	polar_progress_bar.value = float(0)
	hp_progress_bar.value = float(curr_hp)
	xp_progress_bar.value = float(curr_xp)
	
	polar_progress_bar.hide()
	hp_progress_bar.hide()
	xp_progress_bar.hide()

func _process(delta: float) -> void:
	self.polar_progress_bar.max_value = PolarTimer.wait_time
	if PolarTimer.is_stopped():
		self.polar_progress_bar.value = 0
	else:
		self.polar_progress_bar.value = PolarTimer.wait_time - PolarTimer.time_left
	self.curr_hp = Global.player.hurtbox.curr_hp
	self.max_hp = Global.player.hurtbox.curr_max_hp
	
	#self.curr_xp = Global.player.curr_xp
	#self.max_xp = Global.player.max_xp
	
	#polar_progress_bar.value = lerp(polar_progress_bar.value, float(curr_polar_prog), delta * BAR_SPEED)
	hp_progress_bar.value = lerp(hp_progress_bar.value, float(curr_hp), delta * BAR_SPEED)
	xp_progress_bar.value = lerp(xp_progress_bar.value, float(curr_xp), delta * BAR_SPEED)

func _on_player_player_hp_changed(curr_hp: int, max_hp: Variant) -> void:
	self.max_hp = max_hp
	self.curr_hp = curr_hp

func _on_player_xp_changed(level: int, current_xp: int, xp_cap: int) -> void:
	self.max_xp = xp_cap
	self.curr_xp = current_xp
	
func blink_polar_prog() -> void:
	self.polar_progress_bar.show()
	self.animation_player.play("blink_timer")

func show_hud() -> void:
	polar_progress_bar.show()
	hp_progress_bar.show()
	xp_progress_bar.show()
