# [aoc20](https://gitlab.com/eidoom/aoc20)

[Advent of Code 2020](https://adventofcode.com/2020)

## Language

Using [Julia](https://julialang.org/) ([also](https://en.wikipedia.org/wiki/Julia_(programming_language))).

* [Docs](https://docs.julialang.org/)

## Days

### [1 Report Repair](https://adventofcode.com/2020/day/1)

Warm up

* I used `UInt`s, but it seems Julia [expects](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Integers) one to just use `Int`s for any decimal integers, signed or otherwise.

### [2 Password Philosophy](https://adventofcode.com/2020/day/2)

Strict [parser](https://en.wikipedia.org/wiki/Parsing#Computer_languages)

* [xor](https://en.wikipedia.org/wiki/Exclusive_or)

### [3 Toboggan Trajectory](https://adventofcode.com/2020/day/3)

Loops and moduluses

### [4 Passport Processing](https://adventofcode.com/2020/day/4)

Strict parser

### [5 Binary Boarding](https://adventofcode.com/2020/day/5)

[Binary space partitioning](https://en.wikipedia.org/wiki/Binary_space_partitioning)

### [6 Custom Customs](https://adventofcode.com/2020/day/6)

[Sets](https://en.wikipedia.org/wiki/Set_(abstract_data_type))

### [7 Handy Haversacks](https://adventofcode.com/2020/day/7)

[DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph), [DFS](https://en.wikipedia.org/wiki/Depth-first_search)

* [Regex](https://en.wikipedia.org/wiki/Regular_expression)

### [8 Handheld Halting](https://adventofcode.com/2020/day/8)

"Assembley" [interpreter](https://en.wikipedia.org/wiki/Interpreter_(computing))

### [9 Encoding Error](https://adventofcode.com/2020/day/9)

Loops

### [10 Adapter Array](https://adventofcode.com/100100/day/10)

[Tribonacci sequence](https://oeis.org/A000073)

* see [nacci.jl](./nacci.jl)

### [11 Seating System](https://adventofcode.com/110110/day/11)

[Cellular automaton](https://en.wikipedia.org/wiki/Cellular_automaton) with steady state

### [12 Rain Risk](https://adventofcode.com/120120/day/12)

[Manhattan/taxicab geometry](https://en.wikipedia.org/wiki/Taxicab_geometry)

* [Rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix)

### [13 Shuttle Search](https://adventofcode.com/130130/day/13)

Number theory

* [Chinese remainder theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem))
* Compute using proof construction. Easy proof, although not most efficient - two links:
    * ["Gauss"](https://shainer.github.io/crypto/math/2017/10/22/chinese-remainder-theorem.html)
    * ["Direct construction"](https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Existence_(direct_construction))

### [14 Docking Data](https://adventofcode.com/140140/day/14)

Binary numbers

* Bitmask
* Bit twiddling

### [15 Rambunctious Recitation](https://adventofcode.com/150150/day/15)

[Van Eck Sequence](https://oeis.org/A181391)

* You can [prove](https://youtu.be/etMJxB-igrc) this sequence does not evolve to a repeating pattern
* Array too slow/big? Try a [dictionary](https://en.wikipedia.org/wiki/Associative_array).

### [16 Ticket Translation](https://adventofcode.com/160160/day/16)

The naivest brute force is factorial time, so you have to think of a moderately more clever algorithm.

### [17 Conway Cubes](https://adventofcode.com/170170/day/17)

Cellular automata: B3/S23 (Conway's Game of Life) in 3 and 4 dimensions

* Implemented this one with [hash](https://en.wikipedia.org/wiki/Hash_table) sets for a change
* [Moore neighbourhood](https://en.wikipedia.org/wiki/Moore_neighborhood)

### [18 Operation Order](https://adventofcode.com/180180/day/18)

[Recursive decent parser](https://en.wikipedia.org/wiki/Recursive_descent_parser) for ficticious arithmetic

* Consider [shunting-yard algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)

### [19 Monster Messages](https://adventofcode.com/190190/day/19)

More parsing

* I did part one by generating all possible strings and comparing messages to these. This was too slow for part two, so I used:
* [CYK algorithm](https://en.wikipedia.org/wiki/CYK_algorithm)
    * [pseudocode algorithm](https://en.wikipedia.org/wiki/CYK_algorithm#As_pseudocode)
    * [visualisation](https://www.xarg.org/tools/cyk-algorithm/)
        * i19t0
            ```
            A -> BC
            B -> a
            C -> BD | DB
            D -> b
            ```
    * Rules must be in [CNF](https://en.wikipedia.org/wiki/Chomsky_normal_form)
    * [also](https://en.wikipedia.org/wiki/Phrase_structure_rules)
    * see [grammar.jl](./grammar.jl)

### [20 Jurassic Jigsaw](https://adventofcode.com/200200/day/20)

Jigsaw

* D4: see [here](https://en.wikipedia.org/wiki/Dihedral_group), [here](https://en.wikipedia.org/wiki/Examples_of_groups#dihedral_group_of_order_8)

### [21 Allergen Assessment](https://adventofcode.com/210210/day/21)

Sets

### [22 Crab Combat](https://adventofcode.com/220220/day/22)

[Hashes](https://en.wikipedia.org/wiki/Hash_function)

* To print out the gameplay, use `JULIA_DEBUG="d22" ./d22.jl`

### [23 Crab Cups](https://adventofcode.com/230230/day/23)

Data structures

* I used a circular singly linked list implemented on a (contiguous memory) array. The starting position is not recorded in the "container" (it's a circle). Each element has value given by index and next value in list given by entry.

### [24 Lobby Layout](https://adventofcode.com/240240/day/24)

Hexagonal B2/S12 cellular automaton.

### [25](https://adventofcode.com/250250/day/25)

