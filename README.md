# caseLooper

A Lua-based script that loops through and controls test cases for your program using input redirection. Test inputs and expected outputs are stored in separate files for automated verification.

## Features
- Supports running multiple test cases.
- Compares script output to expected results.
- Displays detailed test results when requested.

## Prerequisites
- **Lua** installed on your system.
- A `tests` directory at the same level as the script containing:
  - `in<identifier>[.extension]` files for inputs.
  - `out<identifier>[.extension]` (Optional) files for expected outputs.

## Installation

1. Compile the `fsystem.c` file into a shared object library:
   ```sh
    gcc -shared -fPIC -o ./lib/fsystem.so ./src/fsystem.c -I/usr/include/lua5.4 -llua5.4

   ```

## Usage

1. Prepare your input and output files in a tests folder.

2. Run caseLooper.

```sh
lua caseLooper.lua -i <interpreter> -s <script> [-u <file>] [-d]
```

### Options
- `-h` : Display help information.
- `-s` : Script to test (required).
- `-i` : Interpreter (e.g., lua, python, php) to use (required).
- `-u` : Run a single test file (optional) ; if omitted, all tests will be run (optional)
- `-d` : Display detailed input and output comparison (optional).

### Example

```sh
lua caseLooper.lua -i lua -s example.lua -d
```
This command runs `example.lua` with the Lua interpreter, comparing output against all test cases, and displays detailed results.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Feedback, bug reports, and feature requests are welcome. Feel free to submit an issue or a pull request!

