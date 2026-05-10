class_name TextBox extends Node2D

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var first_time_big: bool = true

var texts: Dictionary = {
	Global.State.BIG: [
		"GET OUT OF MY PROPERTY!",
		"WHO WANTS A PIECE OF ME?!",
		"I’LL TEAR THIS PLACE APART!",
		"YOU THINK YOU’RE TOUGH?!",
		"TIME TO WRECK EVERYTHING!",
		"GRRRR!!! WHO TOUCHED MY FISH?!",
		"I AM THE KING OF THIS ICEBERG!",
		"DOES THIS LOOK LIKE A CUDDLE PARTY?!",
		"I’LL TURN YOU INTO A SNOW CONE!",
		"WHO NEEDS HIBERNATION?!",
		"RUN BEFORE I GET REALLY MAD!",
		"SOMEONE’S GETTING CLAWED TODAY!",
		"I’M NOT FAT, I’M INTIMIDATING!",
		"LET’S SEE HOW FAST YOU CAN RUN!",
		"THIS ICE IS MINE, BACK OFF!",
		"I’LL SMASH YOU LIKE A SNOWFLAKE!",
		"YOU WANT A HUG? TOO BAD!",
		"I’M NOT MAD, I’M FURIOUS!",
		"YOU’RE GONNA MELT IN MY ANGER!",
		"SAY HELLO TO MY LITTLE FRIEND!",
		"THIS IS MY TERRITORY!",
		"SNOWBALL FIGHT? I’LL WIN!",
		"YOU THINK YOU CAN HANDLE ME?!",
		"YOUR END IS NEAR, TINY HUMAN!",
		"LEAVE BEFORE I COUNT TO ONE!",
	],
	Global.State.SMALL: [
		"Mommy, I’m scared!",
		"Please don’t hurt me!",
		"I’m just a fluffy bear!",
		"Why is everyone so mean?",
		"Is it hibernation time yet?",
		"I think I need a hug",
		"Don’t look at me like that!",
		"I didn’t mean to roar...",
		"Can we all just get along?",
		"Why is the world so cold?",
		"I just want a friend...",
		"I think I’m going to cry!",
		"Is it safe to come out now?",
		"I think I’ll just go home.",
		"Please don’t eat me!",
		"I’m really more of a lover than a fighter.",
		"Can we talk about our feelings?",
		"I’m too soft for this",
		"I don’t like confrontation.",
		"Maybe if I close my eyes, you’ll go away.",
		"I feel so small right now.",
		"Can we just build a snowman instead?",
		"Please don’t chase me!",
		"I didn’t mean to scare you!"
	]
}

func _ready() -> void:
	self.hide()

func show_first() -> void:
	show_text("What a peacful day, how could it go wrong?")

func show_random_by_state(state: Global.State) -> void:
	if first_time_big:
		first_time_big = false
		show_text("AHHH I'M ANGRY FOR NO REASON!!!")
		return
	var txt: String = texts[state].pick_random()
	show_text(txt)

func show_text(txt: String) -> void:
	self.label.text = txt
	self.show()
	self.timer.start()

func _on_timer_timeout() -> void:
	self.hide()
