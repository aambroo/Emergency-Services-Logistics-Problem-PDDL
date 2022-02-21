(define (problem problem3) (:domain durativeDelivery)
(:objects
    l1 l2 l3 l4 l5 l6 l7 - location
    c1 c2 c3 c4 c5 c6 c7 - crate
    matteo alice francesco eliana giorgio - person
    meds food - content
    carrier - carrier

    ;adding amount objects
    n1 n2 n3 n4 n5 n6 n7 - amount
)

(:init
    ;crates location
    (crate_at c1 depot)
    (crate_at c2 depot)
    (crate_at c3 depot)
    (crate_at c4 depot)
    (crate_at c5 depot)
    (crate_at c6 depot)
    (crate_at c7 depot)

    ;crate availability
    (not(is_loaded c1))
    (not(is_loaded c2))
    (not(is_loaded c3))
    (not(is_loaded c4))
    (not(is_loaded c5))
    (not(is_loaded c6))
    (not(is_loaded c7)) 

    (not(is_delivered c1))
    (not(is_delivered c2))
    (not(is_delivered c3))
    (not(is_delivered c4))
    (not(is_delivered c5))
    (not(is_delivered c6)) 
    (not(is_delivered c7)) 

    ;crate content
    (contains c1 meds)
    (contains c2 meds)
    (contains c3 meds)
    (contains c4 food)
    (contains c5 food)
    (contains c6 meds)
    (contains c7 food)


    ;robot location
    (robot_at operator depot)
    (is_empty operator)

    ;carrier location
    (carrier_at carrier depot)
    ;initialize carrier crate_count
    ;(= (crate_count carrier) 0)        <-- can't use no more
    (crate_count carrier n0)            ;resets the counter

    ;people location
    (person_at matteo l1)
    (person_at eliana l2)
    (person_at francesco l2)
    (person_at alice l7)
    (person_at giorgio l3)

    ;add-pop relationships: \ref{elevator problem}
    (add n0 n1)
    (add n1 n2)
    (add n2 n3)
    (add n3 n4)
    (add n4 n5)
    (add n5 n6)
    (add n6 n7)
    (pop n7 n6)
    (pop n6 n5)
    (pop n5 n4)
    (pop n4 n3)
    (pop n3 n2)
    (pop n2 n1)
    (pop n1 n0)

    ;people needs
    (needs eliana food)
    (needs matteo food)
    (needs matteo food)
    (needs alice meds)
    (needs francesco meds)
    (needs francesco food)


)

(:goal (and
    
    ;Eliana needs food
    ;(or
    ;    (served eliana f1)(served eliana f2)(served eliana f3)
    ;)
    (served eliana)
    (not (needs eliana food))

    
    ;Matteo needs 2 crates of meds
    ;(or
    ;    (served matteo f1)(served matteo f2)(served matteo f3)
    ;)
    ;(or
    ;    (served matteo m1)(served matteo m2)(served matteo m3)
    ;)
    (served matteo)
    (not (needs matteo meds))(not (needs matteo meds))

    ;Francesco needs both food and meds
    ;(or
    ;    (served francesco m1)(served francesco m2)(served francesco m3)
    ;)
    ;(or
    ;    (served francesco m1)(served francesco m2)(served francesco m3)
    ;)
    (served francesco)
    (not (needs francesco food))(not (needs francesco meds))


    ;Alice needs meds
    ;(or
    ;    (served alice f1)(served alice f2)(served alice f3)
    ;)
    (served alice)
    (not (needs alice meds))
))

)
