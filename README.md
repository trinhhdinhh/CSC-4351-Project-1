# Geaux Lexer Project

A lexical analyzer (lexer) for the Geaux programming language built using ANTLR 4.13.2. This project tokenizes Geaux source code files and identifies language constructs such as keywords, operators, identifiers, and literals.

## Using the run.sh Script (Recommended)

The easiest way to build and run the project is using the provided script:

```bash
# Run with the default test file (test.g)
bash run.sh

# Run with a specific input file
bash run.sh examples/keywords.g

# Run with a test file
bash run.sh tests/test_0.g
```

The `run.sh` script automatically:
1. Cleans previous builds
2. Generates the lexer from ANTLR grammar
3. Compiles all Java source files
4. Runs the lexer on the specified input file

## Understanding the Output

The lexer outputs tokens in the following format:

```
TOKEN_TYPE      TOKEN_TEXT line=X col=Y
```

Example output for `examples/keywords.g`:
```
OP              +          line=1 col=0
KWFUN           fun        line=2 col=0
KWVAR           var        line=3 col=0
IDENT           _          line=4 col=0
...
EOF
```

Each line shows:
- **TOKEN_TYPE**: The category of the token (keyword, operator, identifier, etc.)
- **TOKEN_TEXT**: The actual text from the source file
- **line**: Line number in the source file (1-indexed)
- **col**: Column position (0-indexed)

## Running Tests

To run all tests and compare against expected output:

```bash
bash test.sh
```

This script will:
- Run the lexer on all test files in the `tests/` directory
- Compare output with expected results
- Display passing and failing tests

## Example Files

The `examples/` directory contains sample input files demonstrating different language features:

- **keywords.g** - Tests keyword and operator recognition
- **numbers.g** - Tests numeric literal parsing
- **strings.g** - Tests string literal handling
- **ruleOrdering.g** - Tests lexer rule precedence

Try running these examples:

```bash
bash run.sh examples/keywords.g
bash run.sh examples/numbers.g
bash run.sh examples/strings.g
```

# Troubleshooting

# "Command not found: java"
- Install JDK and ensure it's in your PATH
- On macOS: `brew install openjdk`
- On Ubuntu/Debian: `sudo apt-get install default-jdk`

# "Permission denied" when running scripts
```bash
chmod +x run.sh
chmod +x test.sh
```

# Development

To modify the lexer:
1. Edit `Parse/gLexer.g4` to change the grammar rules
2. Run `bash run.sh` to regenerate and test
3. Use the example files to verify your changes

