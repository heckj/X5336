# Parametric L-System Grammar

## Inspiration

Inspired by the lcfg and L+C language implementations detailed within:

- [The Design and Implementation of the L+C Modeling Language](http://algorithmicbotany.org/papers/l+c.tcs2003.html) (R Karwowski 2003)
- [Parametric L-systems and Their Application to the Modelling and Visualization of Plants](http://algorithmicbotany.org/papers/hanan.dis1992.html) (J Hanan 1992)

Where the L+C language layered over C and C++ for representations, this is intended to be a fully immersed domain-specific language and associated interpretter, implemented using the Swift programming language. 
The interpretation section of this interpreter can be entirely separate, or at least modular, to allow for significantly different interpretation engines to be applied.
For example, the 2D canvas visualization is likely significantly simpler than a 3D represeentation that generates mesh, textures, etc.

## Goals

My initial goal for this project is a system that can be used to create procedural generation of plants, with enough flexibility for a variety of levels of detail in the end result, multiple visual representations. 
A secondary goal is to potentially enable a timed parametric L-system that uses a time-interval input to process the L-system, allowing real-time visualization of growth and evolution of the model.

A side goal is to implement the core of this rule parsing, evaluation, and intepretation system in just the open-source available elements of swift, in order to allow the system to be used cross-architecture as well as cross-platform. 
I specifically want to enable server-side processing of rule systems into stateful representations that could then be transfered and interpretted into relevant visualizations within another system.  

## Grammar scratchpad


Key elements of a parametric L-system:

- direction
  - intepreting the L-system from the right or left
- constants
  - for use within the rewriting rules
- module definitions
  - need to define the number of parameters
  - may be worth of keeping notes in there for what it represents
- axiom
  - the initial starting position module, and any initial variable state for it
- rewriting rules
  - positional grammar with modules, optional predicates for parameter matching within module(s)
  - variable assignment statements when matched that evaluate values from modules and constants
  - if/then statement for evaluating if the rule applies
  - variable assignment statements when secondary match that evaluate values from modules, existing variables, and constants
  - optional stochastic assignment, with a default of 100%
  - producing expressions for replacement modules with parameters assigned from existing variables
- decomposition rules
  - non-parametric replacement of elements - a simplified rule structure, but maybe not needed
- interpretation rules
  - converting the module & parameter interpretation into an external/visual representation (2D, 3D, etc)

I'm thinking that this grammar won't have the ability to define its own functions, instead relying on a "standard library" of functions
available within the interpretter, likely which overlays swift functions or its standard library.

```
program        → directionStmt? constantsDecl? moduleDecl* axiomDecl produceDecl* decomposeDecl? EOF ;

// optional direction statement - default is 'forward', also consider 'ltr' and 'rtl' as replacements
directionStmt  → "forward"
               | "backward" ;

constantsDecl  → "{" varDecl* "}" ;
moduleDecl     → "module" "{" IDENTIFIER "(" moduleArguments? ")" "}" ;
moduleArgument → IDENTIFIER ( "," IDENTIFIER )* ;
axiomDecl      → "axiom" moduleStmt* ;

produceDecl    → context block? "(" logic_or ")" block? "produces" moduleStmt* ";" ;
decomposeDecl  → context "produces" moduleStmt*  ";" ;

context        → moduleStmt "<<"? moduleStmt? "<"? moduleStmt? ">"? moduleStmt? ">>"? ;
moduleStmt     → IDENTIFIER "(" moduleCond? ")" ;
moduleCond     → logic_or ( "," logic_or )* ;

moduleStmt     → IDENTIFIER "(" moduleArgs? ")" ;
moduleArgs   → expression ( "," expression )* ;

// more classic programming statements, including
// - if/then control flow statements
// - expression evaluation, including assignment, statements
// - calling a function with the expectation of a built-in standard library
//   for the basic trig/mathematical goodies.
//
// Currently excluding any looping controls (for/while) and print statements

statement      → exprStmt
//               | forStmt
               | ifStmt
//               | printStmt
//               | whileStmt
               | block ;

//forStmt        → "for" "(" ( varDecl | exprStmt | ";" )
//                 expression? ";"
//                 expression? ")" statement ;
ifStmt         → "if" "(" expression ")" statement
               ( "else" statement )? ;
exprStmt       → expression ";" ;
//printStmt      → "print" expression ";" ;
//whileStmt      → "while" "(" expression ")" statement ;

block          → "{" declaration* "}" ;

call           → primary ( "(" arguments? ")" )* ;
arguments      → expression ( "," expression )* ;

expression     → assignment ;
assignment     → IDENTIFIER "=" assignment
               | logic_or ;
logic_or       → logic_and ( "or" logic_and )* ;
logic_and      → equality ( "and" equality )* ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;
unary          → ( "!" | "-" ) unary | call ;
primary        → "true" | "false" | "nil"
               | NUMBER | STRING
               | "(" expression ")"
               | IDENTIFIER ;
```
