# Problem3
- ~~Initially, we kept the domain as was formulated in Problem2. Turns out that neither LAMA, nor OPTIC support ADL operands/fluents.~~
- As a result, we were forced to shift to an ADL-less and :typing-less domain.

## Changes:
### domain3.pddl
- `crate_count` check has been replaced with a much more _static_ update task of each crate every time a crate is being _loaded_ or _delivered_.
- `all over` (global variable) is set as a precondition of each loading/unloading action to prevent multiple robots from loading/unloading multiple crates at a time. This was not implemented in the first place, but turned out to be vital to avoid loosing track of the `crate_conut`. 
- `empty_check` to prevent the carrier to leave the depot empty is *removed*.

### problem3.pddl
- `or` statements used in previous problem formulations must be avoided because _negative preconditions_ are not supported by OPTIC planner.
- by removing `or` from the goal statement we are forced to drop the possibility of having multiple crates delivered to the same person.
- there is, however, a way around this problem --> which is to replace the `served` predicate with two different predicates: `(needs ?p - person ?cont - content)`, and  `(not_needs ?p - person ?cont - cont)`. Despite this 'trick' what remains not possible achieving is having two crates with the same content delivered to the same person.
