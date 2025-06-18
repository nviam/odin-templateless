package mustache

import "base:runtime"
import "core:reflect"
import "core:strconv"
import "core:log"

decode :: proc( v: any, key: string ) -> string {

	if v == nil do return ""

	ti := runtime.type_info_base(type_info_of(v.id))
	a := any{v.data, ti.id}

	#partial switch info in ti.variant {

	case runtime.Type_Info_Struct:
		return decode( reflect.struct_field_value_by_name(v, key), "." )

	case runtime.Type_Info_String:
		if key != "." do return ""

		switch t in a {
		case string:
			return t
		case cstring:
			return string(t)
		}

	case runtime.Type_Info_Integer:
		if key != "." do return ""

		buf: [40]byte
		u := cast_any_int_to_u128(a)

		return strconv.append_bits_128(buf[:], u, 10, info.signed, 8*ti.size, "0123456789", nil)
	case runtime.Type_Info_Enum:
		return decode(any{v.data, info.base.id}, key)
	}

	return ""
}


@(private)
cast_any_int_to_u128 :: proc(any_int_value: any) -> u128 {
	u: u128 = 0

	switch i in any_int_value { 
		case i8:      u = u128(i)
		case i16:     u = u128(i)
		case i32:     u = u128(i)
		case i64:     u = u128(i)
		case i128:    u = u128(i)
		case int:     u = u128(i)
		case u8:      u = u128(i)
		case u16:     u = u128(i)
		case u32:     u = u128(i)
		case u64:     u = u128(i)
		case u128:    u = u128(i) 
		case uint:    u = u128(i)
		case uintptr: u = u128(i) 

		case i16le:  u = u128(i)
		case i32le:  u = u128(i)
		case i64le:  u = u128(i)
		case u16le:  u = u128(i)
		case u32le:  u = u128(i)
		case u64le:  u = u128(i)
		case u128le: u = u128(i) 
		case i16be:  u = u128(i)
		case i32be:  u = u128(i)
		case i64be:  u = u128(i)
		case u16be:  u = u128(i)
		case u32be:  u = u128(i)
		case u64be:  u = u128(i)
		case u128be: u = u128(i)
	}

	return u;
}
