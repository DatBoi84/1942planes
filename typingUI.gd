extends CanvasLayer
var cursor_flash_timer := 0.0
var cursor_visible := true
var cursor_color := "white"
@onready var health_bar = $HealthBar
@onready var ammo_label = $AmmoLabel
@onready var ammo_count_label = $AmmoCountLabel
var low_ammo_threshold := 5
var is_blinking := false
var blink_timer := 0.0
var blink_state := false


@export var full_paragraph : String = "In physics, force is defined as any interaction that, when unopposed, will change the motion of an object. One of the most fundamental laws governing motion is Newton's Second Law, which states that force equals mass times acceleration, or F = ma. This means that an object's acceleration is directly proportional to the force applied and inversely proportional to its mass."
@export var visible_letter_count = 100
var letter_pointer = 0
var typed_letters := 0 

@export var max_health := 5
var current_health := max_health



func _ready():
	update_ammo_display()
	update_health_display()
	update_ammo_counter(typed_letters) 
	print("✅ AmmoCountLabel type is:", ammo_count_label.get_class())


func update_ammo_display():
	var typed = "[color=yellow]" + full_paragraph.substr(letter_pointer, typed_letters) + "[/color]"

	var next_letter = ""
	if letter_pointer + typed_letters < full_paragraph.length():
		var next_char = full_paragraph[letter_pointer + typed_letters]
		if cursor_visible:
			next_letter = "[color=" + cursor_color + "][u]" + next_char + "[/u][/color]"
		else:
			next_letter = "[color=#444]" + next_char + "[/color]"

	var untyped_start = letter_pointer + typed_letters + 1
	var untyped_len = visible_letter_count - typed_letters - 1
	var untyped = full_paragraph.substr(untyped_start, untyped_len)

	ammo_label.bbcode_enabled = true
	ammo_label.text = typed + next_letter + untyped

func update_health_display():
	if health_bar:
		health_bar.value = current_health
	else:
		print("❌ HealthBar not found!")

func take_damage():
	if current_health > 0:
		current_health -= 1
		update_health_display()
		print("💥 Took damage! Health left:", current_health)
	
	if current_health <= 0:
		print("💀 Game Over!")

func use_ammo_letter():
	if letter_pointer < full_paragraph.length():
		letter_pointer += 1
		typed_letters = max(typed_letters - 1, 0)
		update_ammo_display()
		update_ammo_counter(typed_letters)



func _unhandled_input(event):
	print("✅ Typed letters:", typed_letters)
	if event is InputEventKey and event.pressed and not event.echo:
		var typed_char = String.chr(event.unicode) if event.unicode > 0 else ""
		if typed_char.length() == 1 and letter_pointer + typed_letters < full_paragraph.length():
			var next_char = full_paragraph[letter_pointer + typed_letters]
			if typed_char.to_lower() == next_char.to_lower():
				typed_letters += 1
				cursor_color = "green"
				update_ammo_counter(typed_letters)
			else:
				cursor_color = "red"
			
			await get_tree().create_timer(0.15).timeout
			cursor_color = "white"

func _process(delta):
	cursor_flash_timer += delta
	if cursor_flash_timer >= 0.5:
		cursor_visible = !cursor_visible
		cursor_flash_timer = 0.0
	update_ammo_display()

func update_ammo_counter(current_ammo: int):
	ammo_count_label.text = "Ammo: [color=yellow]" + str(current_ammo) + "[/color]"
	ammo_count_label.bbcode_enabled = true
