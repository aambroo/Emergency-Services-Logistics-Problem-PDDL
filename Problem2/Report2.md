# Problem2
Let ?r - robot be a forklift truck, performing load/unload tasks.
The autonomous robotic agent operates the delivery truck (carrier) performing loading/unloading tasks also at ?to location(s).
Let ?k - carrier be a delivery truck.
Let ?p - person be a person in need of supplies (food, meds, both, none)

- added: crate count to carrier
- added: action `back_to_base`
- updated: `(is_empty ?r)` with counter control `(< (crate_count ?k) 4)`
- updated: `(not (is_empty ?r))` with counter increment `(increase (crate_count) 1)`