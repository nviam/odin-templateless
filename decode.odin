package mustache

import "core:reflect"
import "core:strings"
import "core:log"
import "core:fmt"

decode :: proc( v: any, key: string ) -> any {
	if v == nil do return ""

	v := reflect.any_base(v)
	ti := type_info_of(v.id)

	switch  {
	case reflect.is_struct(ti):
		newkey, err := strings.split_after_n(key, ".", 2)

		if len(newkey) != 2 || err != nil {
			return decode( reflect.struct_field_value_by_name(v, key), "." )
		}

		return decode( reflect.struct_field_value_by_name(v, newkey[0][:len(newkey[0])-1]), newkey[1] )
	case reflect.is_string(ti):
		if key != "." do return ""
		return  v
	case reflect.is_integer(ti):
		if key != "." do return ""
		return  v
	case reflect.is_enum(ti):
		return decode(any{v.data, ti.id}, key)
	case reflect.is_slice(ti):
		if key != "." do return ""
		return  v
	case:
		log.warnf("%v", ti)
	}

	return ""
}

decode_string :: proc( v: any, key: string ) -> string {
	return fmt.tprintf("%v", decode(v, key))
}

preprocess :: proc( r: ^strings.Reader, v: any, key: string ) -> string {
	if v == nil do return ""

	save := r.i

	t := reflect.any_base(decode(v, key))
	ti := type_info_of(t.id)

	ret : string
	switch  {
	case reflect.is_slice(ti):
		for i in 0..<reflect.length(t) {
			elem :=reflect.index(t, i);

			strings.reader_seek(r, save, .Start)
			tmp := mustache(r, elem, key)
			defer delete(tmp)

			ret = strings.concatenate({ret, tmp})
			log.infof(ret)
		}
	}

	return ret
}
