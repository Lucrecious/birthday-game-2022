extends AudioStreamPlayer

const DisgustedStelios := [
	preload('res://assets/sounds/disgusted_stelios.wav'),
]

const DisgustedNick := [
	preload('res://assets/sounds/disgusted_nick.wav'),
	preload('res://assets/sounds/weird_nick.wav')
]

func _ready() -> void:
	var item_pickup := NodE.get_sibling_with_error(self, ItemPickUp) as ItemPickUp
	item_pickup.connect('scored', self, '_on_scored')

func _on_scored(type: int, _amount: int) -> void:
	if type != PickUpItem.Type.Alcohol:
		return
	
	play()

var disgusted_audio := []
func set_mode(mode: int) -> void:
	if mode == GameMode.Name.Nick:
		disgusted_audio = DisgustedNick
	elif mode == GameMode.Name.Stelios:
		disgusted_audio = DisgustedStelios

func play(start_at := 0.0) -> void:
	if playing:
		return
	
	stream = disgusted_audio[randi() % disgusted_audio.size()]
	.play(start_at)
