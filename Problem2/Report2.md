# Problem2
Let ?r - robot be a forklift truck, performing load/unload tasks.
Let ?k - carrier be a deliver truck. Hence in need of ?r for all load/unload operations (also outside the warehouse).
- added: crate count to carrier
- added: action `back_to_base`
- updated: `(is_empty ?r)` with counter control `(< (crate_count ?k) 4)`
- updated: `(not (is_empty ?r))` with counter increment `(increase (crate_count) 1)`