(define (problem problem2_no_fluents) (:domain normalDelivery_no_fluents)
(:objects
    l1 l2 l3 l4 l5 l6 l7 - location
    matteo alice francesco eliana giorgio - person
    f1 f2 f3 f4 - food
    m1 m2 m3 - meds
    carrier - carrier

    ;adding amount objects
    n1 n2 n3 n4 n5 n6 n7 - amount
)

(:init
    ;crates location
    (crate_at f1 depot)
    (crate_at f2 depot)
    (crate_at f3 depot)
    (crate_at f4 depot)
    (crate_at m1 depot)
    (crate_at m2 depot)
    (crate_at m3 depot)


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

    ;every person is not served
    
    
    

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


)

(:goal (and
    
    ;Eliana needs food
    (or (served eliana f1)(served eliana f2)(served eliana f3)(served eliana f4))
    ;(exists (?c - food) (and (served eliana ?c)))


    
    ;Matteo needs 2 crates of meds
    (or (served matteo f1)(served matteo f2)(served matteo f3)(served matteo f4))
    (or (served matteo m1)(served matteo m2)(served matteo m3))
    ;(exists (?c - meds) (and (served matteo ?c)))
    

    ;Francesco needs both food and meds
    (or (served francesco m1)(served francesco m2)(served francesco m3))
    (or(served francesco m1)(served francesco m2)(served francesco m3))
    ;(exists (?c - meds) (and (served francesco ?c)))
    ;(exists (?c - food) (and (served francesco ?c)))

    ;Alice needs meds
    (or (served alice f1)(served alice f2)(served alice f3)(served alice f4))
    ;(exists (?c - meds) (and (served alice ?c)))
))

)
