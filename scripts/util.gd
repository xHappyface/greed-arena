extends Node

static func human_readable_number(number: int) -> String:
	var formatted_number: String = ("%d" % [number]).reverse()
	var regex: RegEx = RegEx.new()
	regex.compile(".{1,3}")
	var regex_matches: Array[RegExMatch] = regex.search_all(formatted_number)
	var arr: Array[String] = []
	for regex_match in regex_matches:
		arr.append(regex_match.get_string())
	formatted_number = ",".join(arr).reverse()
	return formatted_number
