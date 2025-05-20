package template

import "core:strings"

/*
template works as a state machine, it manipulates `b` (returned string)
and `key` (placeholder string), according to  the states. No error
returns are needed because if `key` is not close it writes it as
it's not a placeholder
*/

state :: enum {
	writing,
	reading_key,
	open_bracket,
	close_bracket,
}

template :: proc(fmt: string, dict: map[string]string ) -> string {
	b, key: strings.Builder
	defer strings.builder_destroy(&key)

	s:= state.writing

	for c in fmt do switch c {
	case '{':
		switch s {
		case .open_bracket:
			s=.reading_key
		case .close_bracket:
			strings.write_string(&b, "}{" )
			s=.writing
		case .writing:
			s=.open_bracket
		case .reading_key:
			strings.write_rune(&key, '{' )
		}
	case '}':
		switch s {
		case .open_bracket:
			strings.write_string(&b, "{}" )
			s=.writing
		case .close_bracket:
			strings.write_string(&b, dict[strings.to_string(key)] )
			strings.builder_reset(&key)
			s=.writing
		case .writing:
			strings.write_rune(&b, '}' )
		case .reading_key:
			s=.close_bracket
		}
	case:
		switch s {
		case .open_bracket:
			strings.write_rune(&b, '{' )
			strings.write_rune(&b, c )
			s=.writing
		case .close_bracket:
			strings.write_rune(&key, '}' )
			strings.write_rune(&key, c )
			s=.reading_key
		case .writing:
			strings.write_rune(&b, c )
		case .reading_key:
			strings.write_rune(&key, c )
		}
	}

	switch s {
	case .open_bracket:
		strings.write_rune(&b, '{' )
	case .close_bracket:
		strings.write_string(&b,"{{")
		strings.write_string(&b,strings.to_string(key))
		strings.write_rune(&b, '}' )
	case .writing:
	case .reading_key:
		strings.write_string(&b,"{{")
		strings.write_string(&b,strings.to_string(key))
	}

	return strings.to_string(b)
}
