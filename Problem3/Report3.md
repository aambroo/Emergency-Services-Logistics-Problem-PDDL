# Problem3
- Initially, we kept the domain as was formulated in Problem2. Turns out that neither LAMA, nor OPTIC support ADL operands/fluents.
- As a result, we were forced to shift to an ADL-less and :typing-less domain.

## Changes:
### domain3.pddl
- `crate_count` check has been replaced with a much more _static_ update task of each crate every time a crate is being _loaded_ or _delivered_.
- `all over` (global variable) is set as a precondition of each loading/unloading action to prevent multiple robots from loading/unloading multiple crates at a time. This was not implemented in the first place, but turned out to be vital to avoid loosing track of the `crate_conut`. 
- `empty_check` to prevent the carrier to leave the depot empty is *removed*.

### problem3.pddl
- `or` statements used in previous problem formulations must be avoided because not supported by OPTIC planner.