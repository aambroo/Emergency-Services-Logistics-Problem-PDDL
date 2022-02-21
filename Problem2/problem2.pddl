(define (problem problem2) (:domain normalDelivery)
(:objects

    l1 l2 l3 l4 l5 l6 l7 - location
    matteo alice francesco eliana - person
    m1 m2 m3 - meds
    f1 f2 f3 - food
    carrier - carrier
)

(:init
    ;crates location
    (crate_at m1 depot)
    (crate_at m2 depot)
    (crate_at m3 depot)
    (crate_at f1 depot)
    (crate_at f2 depot)
    (crate_at f3 depot)
    ;crate availability
    (is_available m1)
    (is_available m2)
    (is_available m3)
    (is_available f1)
    (is_available f2)
    (is_available f3)

    ;robot location
    (robot_at operator depot)
    ;(is_empty operator)
    ;carrier location
    (carrier_at carrier depot)
    ;initialize carrier crate_count
    (= (crate_count carrier) 0)

    ;people location
    (person_at matteo l1)
    (person_at eliana l2)
    (person_at francesco l2)
    (person_at alice l7)

    ;initialize total_cost to zero
    (= (total_cost) 0)

)

(:goal (and
    
    ;Eliana needs food
    (or (served eliana f1)(served eliana f2)(served eliana f3))
    
    ;Matteo needs both food and meds
    (or (served matteo f1)(served matteo f2)(served matteo f3))
    (or (served matteo m1)(served matteo m2)(served matteo m3))

    ;Francesco needs 2 med crates
    (or (served francesco m1)(served francesco m2)(served francesco m3))
    (or (served francesco m1)(served francesco m2)(served francesco m3))

    ;Alice needs food
    (or (served alice f1)(served alice f2)(served alice f3))
))
(:metric minimize 
    (total_cost)
)

)
