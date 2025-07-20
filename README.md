# 🚀 Lambda Calculus REPL

<div align="center">

**A powerful Read-Eval-Print Loop for the untyped Lambda Calculus**

*Built with Wolfram Mathematica*

---

*Developed as partial fulfillment for course 2360651 - Advanced Topics in Software Engineering*  
*Technion, Spring 2024/25 • Supervised by Yossi Gil*

</div>

## ✨ Features

### 🔧 Core Functionality
- **🔤 Tokenization** - Intelligent parsing of lambda expressions into token streams
- **🌳 AST Generation** - Converts tokens into Abstract Syntax Trees following lambda calculus grammar
- **⚡ Reduction Engine** - Implements normal-order beta-reduction with alpha-conversion and eta-reduction
- **🎨 Pretty Printing** - Clean, readable output with optimized parentheses placement

### 🧮 Mathematical Operations
- **🔢 Church Numerals** - Full support for Church numeral arithmetic
  - `SUCC`, `PLUS`, `MULT`, `PRED`, `MINUS`
  - `ISZERO`, `LEQ` (less-than-or-equal)
- **🔀 Church Booleans** - Complete boolean logic system
  - `TRUE`, `FALSE`, `IF`, `NOT`
  - `AND`, `OR`, `XOR`

### 🔄 Advanced Features
- **📝 Macro Definitions** - Create custom shortcuts with `#define` syntax
- **♻️ Y Combinator** - Built-in support for recursive function definitions
- **📁 File I/O** - Read from files and log all interactions
- **🛡️ Error Handling** - Robust error reporting and graceful failure handling

## 🚀 Getting Started

### Prerequisites
```mathematica
Wolfram Mathematica (Version 10.0+)
```

### 📦 Installation

1. **Save the Package**
   ```
   MyLambdaREPL.wl
   ```

2. **Add to Mathematica Path**
   ```mathematica
   (* Option 1: Applications directory *)
   FileNameJoin[{$UserBaseDirectory, "Applications"}]
   
   (* Option 2: Custom directory *)
   AppendTo[$Path, "path/to/your/directory"]
   ```

3. **Load the Package**
   ```mathematica
   Needs["MyLambdaREPL`"]
   ```

## 💡 Usage

### 🎮 Starting the REPL

| Mode | Command | Description |
|------|---------|-------------|
| **Interactive** | `LambdaREPL[]` | Standard notebook interaction |
| **File Input** | `LambdaREPL["input.txt"]` | Read from file, output to notebook |
| **File Output** | `LambdaREPL["", "output.txt"]` | Notebook input, save to file |
| **Full File Mode** | `LambdaREPL["input.txt", "output.txt"]` | Complete file-based operation |

### ⚙️ Configuration

Adjust the maximum reduction steps:
```mathematica
MyLambdaREPL`LambdaStepNum = 500;  (* Default: 100 *)
LambdaREPL[]
```

## 📖 Examples

### 🔤 Basic Lambda Expressions

```mathematica
λ> (\x.x) y
Reduction Chain:
(\x.x) y
y
Out: y
```

### 📚 Using Let Expressions

```mathematica
λ> let id = (\x.x) in id A
Reduction Chain:
let id = (\x.x) in id A
(\x.x) A
A
Out: A
```

### 🧮 Church Numeral Arithmetic

```mathematica
λ> PLUS TWO THREE
Reduction Chain:
PLUS TWO THREE
... (reduction steps) ...
λf x.f (f (f (f (f x))))
Out: λf x.f (f (f (f (f x))))  (* Church numeral for 5 *)
```

### 📝 Macro Definitions

```mathematica
λ> #define ID = \x.x
Defined macro: ID = λx.x

λ> ID A
Reduction Chain:
ID A
(\x.x) A
A
Out: A
```

### 🔄 Recursive Functions with Y Combinator

```mathematica
λ> #define FACT_GEN = \f n. IF (ISZERO n) ONE (MULT n (f (PRED n)))
Defined macro: FACT_GEN = λf n.IF (ISZERO n) ONE (MULT n (f (PRED n)))

λ> #define FACT = Y FACT_GEN
Defined macro: FACT = Y FACT_GEN

λ> FACT TWO
Reduction Chain:
FACT TWO
... (reduction steps) ...
λf x.f (f x)
Out: λf x.f (f x)  (* Church numeral for 2! = 2 *)
```

## 📋 Language Reference

### 🔤 Syntax Elements

| Element | Syntax | Example |
|---------|--------|---------|
| **Variables** | `x`, `y`, `myVar` | `x` |
| **Abstractions** | `\x.body` or `@x.body` | `\x.x` |
| **Applications** | `f x` | `(\x.x) y` |
| **Let Expressions** | `let var = val in body` | `let id = \x.x in id A` |
| **Numbers** | `0`, `1`, `2`, `3`... | `PLUS 2 3` |

### 🧮 Built-in Functions

#### Arithmetic Operations
- `SUCC` - Successor function
- `PLUS` - Addition
- `MULT` - Multiplication  
- `PRED` - Predecessor
- `MINUS` - Subtraction
- `ISZERO` - Zero predicate
- `LEQ` - Less than or equal

#### Boolean Operations
- `TRUE` / `FALSE` - Boolean constants
- `IF` - Conditional expression
- `NOT` - Logical negation
- `AND` / `OR` / `XOR` - Logical operations

#### Special Combinators
- `Y` - Y combinator (fixed-point)
- `I` - Identity combinator
- `K` - Constant combinator  
- `S` - Substitution combinator
- `Z` - Zero combinator

## 🏗️ Project Structure

```
MyLambdaREPL.wl
├── Tokenizer      # String → Tokens
├── Parser         # Tokens → AST  
├── Reducer        # AST → Reduced AST
├── Printer        # AST → Pretty String
├── Macro System   # #define handling
└── REPL Interface # User interaction
```

## 🚪 Exiting

```mathematica
λ> exit
Exiting REPL. Goodbye!

λ> quit
Exiting REPL. Goodbye!
```

## 🤝 Contributing

We welcome contributions! Feel free to:
- 🐛 Report bugs
- 💡 Suggest new features  
- 🔧 Submit pull requests
- 📖 Improve documentation

## 📄 License

This project was developed for academic purposes at Technion - Israel Institute of Technology.

---
