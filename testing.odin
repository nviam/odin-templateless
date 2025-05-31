#+feature dynamic-literals
#+private
package template

import "core:testing"

@(test)
test1 :: proc(t: ^testing.T){
	fmt := "{"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==fmt, tmp)
}
@(test)
test2 :: proc(t: ^testing.T){
	fmt := "}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==fmt, tmp)
}
@(test)
test3 :: proc(t: ^testing.T){
	fmt := "{{"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==fmt, tmp)
}
@(test)
test4 :: proc(t: ^testing.T){
	fmt := "{{}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==fmt, tmp)
}
@(test)
test5 :: proc(t: ^testing.T){
	fmt := "{{}}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="", tmp)
}
@(test)
test6 :: proc(t: ^testing.T){
	fmt := "{{foo}}"

	dict := map[string]string{"foo"="var"}
	defer delete(dict)

	tmp := template(fmt, dict)
	defer delete(tmp)
	testing.expect(t, tmp=="var", tmp)
}
@(test)
test7 :: proc(t: ^testing.T){
	fmt := "{{{}}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="", tmp)
}
@(test)
test8 :: proc(t: ^testing.T){
	fmt := "{{}}}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="}", tmp)
}
@(test)
test9 :: proc(t: ^testing.T){
	fmt := "{{{}}}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="}", tmp)
}
@(test)
test10 :: proc(t: ^testing.T){
	fmt := "{{} }}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="", tmp)
}
@(test)
test11 :: proc(t: ^testing.T){
	fmt := "{{{} }}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="", tmp)
}
@(test)
test12 :: proc(t: ^testing.T){
	fmt := " {{{} }}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==" ", tmp)
}
@(test)
test13 :: proc(t: ^testing.T){
	fmt := "{{{} }} "
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp==" ", tmp)
}
@(test)
test14 :: proc(t: ^testing.T){
	fmt := "{{{}}}"
	tmp := template(fmt,{})
	defer delete(tmp)
	testing.expect(t, tmp=="}", tmp)
}
