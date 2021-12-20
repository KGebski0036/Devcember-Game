class_name TourState
extends Tour

var tourMenager: TourMenager

func _ready() -> void:
	yield(owner, "ready")

	tourMenager = owner as TourMenager

	assert(tourMenager != null)
