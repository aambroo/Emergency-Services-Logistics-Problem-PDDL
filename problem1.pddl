(define (problem problem1) (:domain basicDelivery)
(:objects
    l1 l2 l3 - location
    john alice marco - person
    c1 c2 c3 c4 c5 - crate
    r - robot

)

(:init
    ;crates at depot
    (lays c1 depot)
    (lays c2 depot)
    (lays c3 depot)
    (lays c4 depot)
    (lays c5 depot)
    ;crates content
    (contains_food c1)
    (contains_food c2)
    (contains_meds c3)
    (contains_meds c4)
    (contains_meds c5)
    ;availability
    (is_available c1)
    (is_available c2)
    (is_available c3)
    (is_available c4)
    (is_available c5)

    ;robot at depot
    (is_at_loc r depot)
    (is_empty r)

    ;people at depot
    (is_at john l1)
    (is_at alice l2)
    (is_at marco l2)
    
    ;needs
    (needs_food marco)
    (needs_meds marco)
    (needs_meds alice)


)

(:goal (and
    (food_served marco)
    (meds_served marco)
    (meds_served alice)
))

)
