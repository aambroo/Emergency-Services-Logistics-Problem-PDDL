# Problem2
Let ?r - robot be a forklift truck, performing load/unload tasks.
Let ?k - carrier be a delivery truck.
Let ?p - person be a person in need of supplies (food, meds, both, none)
### Development
The forklift robot is only encharged of loading/unloading tasks. So, the forklift is able to load -- up to a maximum of four -- crates onto the delivery truck (carrier), as well as unload the correct crate(s) to the correct location at which each person is placed. As a result, the robot will move jointly with the carrier.

### Changes wrt Problem1 
- added: crate count to carrier
- added: action `back_to_base`
- updated: `(is_empty ?r)` with counter control `(< (crate_count ?k) 4)`
- updated: `(not (is_empty ?r))` with counter increment `(increase (crate_count) 1)`

### no fluents
- we managed to get rid of fluents so as to being able to find a solution with the LAMA planner.
- however, with this formulation we can no longer deliver multiple crates with the same content to the same person (because one delivery turns the person need state to _satisfied_)