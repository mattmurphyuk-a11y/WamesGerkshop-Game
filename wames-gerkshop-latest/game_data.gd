extends Node

var scores: Array = []

func add_score(seconds: int, kills: int) -> void:
	scores.append({"score": seconds * kills, "seconds": seconds, "kills": kills})
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	if scores.size() > 5:
		scores.resize(5)
