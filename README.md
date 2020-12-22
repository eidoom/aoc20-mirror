# [aoc20](https://gitlab.com/eidoom/aoc20)

[Advent of Code 2020](https://adventofcode.com/2020)

## Language

Using [Julia](https://docs.julialang.org/en/v1/manual/getting-started/), so far at least.

[Handy cheatsheet](https://juliabyexample.helpmanual.io/)

## Days

### 1

Warm up

### 2

Strict [parser](https://en.wikipedia.org/wiki/Parsing#Computer_languages)

### 3

### 4

Strict parser

### 5

[Binary space partitioning](https://en.wikipedia.org/wiki/Binary_space_partitioning)

### 6

[Sets](https://en.wikipedia.org/wiki/Set_(abstract_data_type))

### 7

[DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph), [DFS](https://en.wikipedia.org/wiki/Depth-first_search)

* [Regex](https://en.wikipedia.org/wiki/Regular_expression)

### 8

"Assembley" [interpreter](https://en.wikipedia.org/wiki/Interpreter_(computing))

### 9

### 10

[Tribonacci sequence](https://oeis.org/A000073)

* see [nacci.jl](./nacci.jl)

### 11

[Cellular automaton](https://en.wikipedia.org/wiki/Cellular_automaton) with steady state

### 12

[Manhattan/taxicab geometry](https://en.wikipedia.org/wiki/Taxicab_geometry)

### 13

Number theory

* [Chinese remainder theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem))
* Compute using proof construction. Easy proof, although not most efficient - two links:
    * ["Gauss"](https://shainer.github.io/crypto/math/2017/10/22/chinese-remainder-theorem.html)
    * ["Direct construction"](https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Existence_(direct_construction))

### 14

Binary numbers

* Bitmask
* Bit twiddling

### 15

[Van Eck Sequence](https://oeis.org/A181391)

* You can [prove](https://youtu.be/etMJxB-igrc) this sequence does not evolve to a repeating pattern
* Array too slow/big? Try a [dictionary](https://en.wikipedia.org/wiki/Associative_array).

### 16

The naivest brute force is factorial time, so you have to think of a moderately more clever algorithm.

### 17

Cellular automata: B3/S23 (Conway's Game of Life) in 3 and 4 dimensions

* Implemented this one with [hash](https://en.wikipedia.org/wiki/Hash_table) sets for a change

### 18

[Recursive decent parser](https://en.wikipedia.org/wiki/Recursive_descent_parser) for ficticious arithmetic

* Consider [shunting-yard algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)
* Type annotations (`@time` part two)
    * Before `0.002661 seconds (32.86 k allocations: 2.790 MiB)`
    * After `0.001234 seconds (20.84 k allocations: 2.629 MiB)`

### 19

More parsing

* Consider [CYK algorithm](https://en.wikipedia.org/wiki/CYK_algorithm)
    * [algorithm](https://www.geeksforgeeks.org/cocke-younger-kasami-cyk-algorithm/)
    * [visualisation](https://www.xarg.org/tools/cyk-algorithm/)
        * i19t0
            ```
            A -> BC
            B -> a
            C -> BD | DB
            D -> b
            ```
    * [CNF](https://en.wikipedia.org/wiki/Chomsky_normal_form)
    * [also](https://en.wikipedia.org/wiki/Phrase_structure_rules)
    * see [grammar.jl](./grammar.jl)

### 20

Jigsaw

* D4: see [here](https://en.wikipedia.org/wiki/Dihedral_group), [here](https://en.wikipedia.org/wiki/Examples_of_groups#dihedral_group_of_order_8)

### 21

### 22

[Hashes](https://en.wikipedia.org/wiki/Hash_function)

* To print out the gameplay, use `JULIA_DEBUG="d22" ./d22.jl`

### 23

### 24

### 25

