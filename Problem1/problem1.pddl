(define (problem problem1) (:domain basicDelivery)
(:objects
    depot l1 l2 l3 - location
    matteo alice francesco eliana - person
    m1 m2 m3 - meds
    f1 f2 f3 - food

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
    (is_empty operator)

    ;people location
    (person_at matteo l1)
    (person_at eliana l2)
    (person_at francesco l2)

)

(:goal (and
    
    ;Eliana needs food
    (or
        (served eliana f1)(served eliana f2)(served eliana f3)
    )
    
    ;Matteo needs both food and meds
    (or
        (served matteo f1)(served matteo f2)(served matteo f3)
    )
    (or
        (served matteo m1)(served matteo m2)(served matteo m3)
    )

    ;Francesco needs meds
    (or
        (served francesco m1)(served francesco m2)(served francesco m3)
    )
))

)
