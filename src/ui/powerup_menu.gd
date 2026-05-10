class_name PowerupMenu extends CanvasLayer

@onready var up1: Button = $Control/Ups/Up1
@onready var up2: Button = $Control/Ups/Up2
@onready var up3: Button = $Control/Ups/Up3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var UPGRADES: Dictionary = {
	"ATKSPD": {
		"description": "Faster Attack Speed",
		"func": func(): Global.player.gun.firerate *= 0.9
	},
	"MAX_HP": {
		"description": "Increased Maximum Health",
		"func": func(): Global.player.hurtbox.curr_max_hp += Global.player.hurtbox.curr_max_hp * 0.15
	},
	"HEALTH_REG": {
		"description": "Faster Health Regeneration",
		"func": func(): Global.player.hurtbox.health_regen += 0.6
	},
	"DMG": {
		"description": "Increased Damage",
		"func": func(): Global.player.gun.dmg = DMG_LVL.get(Global.curr_upgrades["DMG"], 9)
	},
	"MAGNET_RADIUS": {
		"description": "Collect Items From Farther Away",
		"func": func(): Global.player.xp_magnet_shape.radius += 50
	},
	"MVM_SPEED": {
		"description": "Faster Movement Speed",
		"func": func(): Global.player.SMALL_BASE_SPEED *= 1.1; Global.player.BIG_BASE_SPEED *= 1.1; 
	}
}

var DMG_LVL : Dictionary = {
	2: 2,
	3: 3,
	4: 4,
	5: 5,
	6: 6,
	7: 7,
	8: 8,
	9: 9,
}

var selected_upgrades: Array = []


func _ready() -> void:
	self.hide()
	Global.level_up.connect(create_upgrade_menu)

func create_upgrade_menu():
	# Choose 3 random upgrades from the dictionary
	#Global.game_root.pause_game()
	AudioManager.level_up.play()
	selected_upgrades = []
	var keys = UPGRADES.keys()
	while selected_upgrades.size() < 3:
		var random_key = keys.pick_random()
		if random_key not in selected_upgrades:
			selected_upgrades.append(random_key)
	
	# Display description and level for each selected upgrade
	up1.text = UPGRADES[selected_upgrades[0]]["description"] + "\n\nLvl: %d" % Global.curr_upgrades[selected_upgrades[0]]
	up2.text = UPGRADES[selected_upgrades[1]]["description"] + "\n\nLvl: %d" % Global.curr_upgrades[selected_upgrades[1]]
	up3.text = UPGRADES[selected_upgrades[2]]["description"] + "\n\nLvl: %d" % Global.curr_upgrades[selected_upgrades[2]]

	
	# Show the upgrade menu
	self.show()
	self.animation_player.play("fade_in")


func _on_up_1_pressed() -> void:
	apply_upgrade(0)


func _on_up_2_pressed() -> void:
	apply_upgrade(1)


func _on_up_3_pressed() -> void:
	apply_upgrade(2)


func apply_upgrade(index: int) -> void:
	# Apply the selected upgrade
	var upgrade_key = selected_upgrades[index]
	Global.curr_upgrades[upgrade_key] = 1 + Global.curr_upgrades[upgrade_key]
	UPGRADES[upgrade_key]["func"].call()
	self.animation_player.play("fade_out")
	await self.animation_player.animation_finished
	self.hide()
	
	Global.game_root.on_powerup_menu = false
	Global.game_root.unpause_game()
	#Global.gained_powerup.emit()
	# Hide the upgrade menu after selecting
