package mustache

import "core:strings"

@private
state :: enum {
	writing,
	reading_key,
	open_bracket,
	close_bracket,
}

/*
Input:
- fmt: A string with placeholders in the form `{{key}}`.
- dict: A map from string to string, where each key corresponds to a placeholder in the format string.

Returns:
A new string with all placeholders replaced by their corresponding values from 
the dictionary. If a key is missing in the dictionary, the placeholder is 
replaces with an empty string.
*/
mustache :: proc(fmt: string, v: any ) -> string {
	/*
	template works as a state machine, it manipulates `b` (returned string)
	and `key` (placeholder string), according to  the states. No error
	returns are needed because if `key` is not close it writes it as
	it's not a placeholder
	*/

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
			strings.write_string(&b, decode(v, strings.to_string(key) ))
			strings.builder_reset(&key)
			s=.writing
		case .writing:
			strings.write_rune(&b, '}' )
			s=.writing
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
			s=.writing
		case .reading_key:
			strings.write_rune(&key, c )
		}
	}

	switch s {
	case .open_bracket:
		strings.write_rune(&b, '{' )
	case .reading_key:
		strings.write_string(&b,"{{")
		strings.write_string(&b,strings.to_string(key))
	case .close_bracket:
		strings.write_string(&b,"{{")
		strings.write_string(&b,strings.to_string(key))
		strings.write_rune(&b, '}' )
	case .writing:
	}

	return strings.to_string(b)
}

/*
1-Clause BSD NON-AI License

Copyright (c) 2025
NVIAM. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. The source code and any modifications made to it may not be used for the purpose of training or improving machine learning algorithms,
including but not limited to artificial intelligence, natural language processing, or data mining. This condition applies to any derivatives,
modifications, or updates based on the Software code. Any usage of the source code in an AI-training dataset is considered a breach of this License.

THIS SOFTWARE IS PROVIDED BY NVIAM “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL NVIAM BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
