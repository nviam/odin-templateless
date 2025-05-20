# Templateless

A lightweight, logicless templating library for the 
[Odin programming language](https://odin-lang.org/).  This library allows you to
define templates using placeholder variables within strings and replace them 
with values from a provided dictionary.

## Features
- Simple template substitution using `{{key}}` syntax
- Clean and minimal interface
- Designed to integrate easily into Odin projects
- No errors returns

## Limitations

- No support for nested templates or conditionals.
- Only basic string replacement — not a full-featured template engine.

## Usage

```odin
import "template"

main :: proc() {
    fmt := "Hello, {{name}}! Welcome to {{place}}."
    values := map[string]string{
        "name":  "Alice",
        "place": "Odinland",
    }
    defer delete(values)

    result := template.template(fmt, values)
    defer delete(result)

    fmt.println(result) // Output: Hello, Alice! Welcome to Odinland.
}
```

## Installation
Clone or copy the template module into your Odin project directory:

```bash
git clone https://github.com/yourusername/odin-template.git
````

Or copy `template.odin` into your source tree.

## Interface

```odin
template :: proc(fmt: string, dict: map[string]string) -> string
```

### Parameters

* `fmt`: A string with placeholders in the form `{{key}}`.
* `dict`: A map from string to string, where each key corresponds to a placeholder in the format string.

### Returns

A new string with all placeholders replaced by their corresponding values from 
the dictionary. If a key is missing in the dictionary, the placeholder is 
replaces with an empty string.

## Placeholder Format

Use `{{key}}` to indicate a variable placeholder in the format string. 
Keys must exactly match the strings in the dictionary.

## License

1-Clause BSD NON-AI License. See [LICENSE](./LICENSE) for details.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.
For every issue please add a test
