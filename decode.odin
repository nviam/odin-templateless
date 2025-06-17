package mustache

import "base:runtime"
import "core:reflect"
import "core:log"

decode :: proc( v: any, key: string ) -> string {

	if v == nil do return ""

	ti := runtime.type_info_base(type_info_of(v.id))
	a := any{v.data, ti.id}

	#partial switch info in ti.variant {

	case runtime.Type_Info_Struct:
		return  decode( reflect.struct_field_value_by_name(v, key), ".")

	case runtime.Type_Info_String:
		switch s in a {
		case string:
			return string(s)
		case cstring:
			return string(s)
		}

	}

	return ""
}
