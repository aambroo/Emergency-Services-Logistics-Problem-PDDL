(define (problem problem1_copy) (:domain basicDelivery_copy)
(:objects
    l1 l2 l3 - location
    john alice marco matteo eliana giorgio francesco - person
    c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 - crate
    r - robot
    carrier - carrier
)

(:init
    ;crates at depot
    (lays c1 depot)
    (lays c2 depot)
    (lays c3 depot)
    (lays c4 depot)
    (lays c5 depot)
    (lays c6 depot)
    (lays c7 depot)
    (lays c8 depot)
    (lays c9 depot)
    (lays c10 depot)

    ;crates content
    (contains c1 food)
    (contains c2 food)
    (contains c3 meds)
    (contains c4 food)
    (contains c5 meds)
    (contains c6 food)
    (contains c7 meds)
    (contains c8 food)
    (contains c9 meds)
    (contains c10 food)

    ;availability
    (is_available c1)
    (is_available c2)
    (is_available c3)
    (is_available c4)
    (is_available c5)
    (is_available c6)
    (is_available c7)
    (is_available c8)
    (is_available c9)
    (is_available c10)

    ;carrier at depot
    (is_at_loc carrier depot)
    (is_empty carrier)
    (= (carrier_capacity) 2)
    (= (amount_loaded carrier) 0)

    ;robot
    (is_free r)

    ;people at depot
    (is_at john l1)
    (is_at alice l2)
    (is_at marco l2)
    (is_at matteo l3)
    (is_at eliana l1)
    (is_at giorgio l2)
    (is_at francesco l3)
    
    ;needs
    (needs marco food)
    (needs marco meds)
    (needs alice meds)
    (needs matteo meds)
    (needs matteo food)
    (needs giorgio food)
    (needs giorgio food)
    (needs francesco meds)


    (= (total_cost) 0)

)

(:goal (and
    (served marco food)
    (served marco meds)
    (served alice meds)
    (served matteo meds)
    (served matteo food)
    (served giorgio food)
    (served giorgio food)
    (served francesco meds)
    
))
(:metric 
    minimize (total_cost)
)

)