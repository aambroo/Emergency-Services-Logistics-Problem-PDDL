(define (problem problem2_no_fluents) (:domain normalDelivery_no_fluents)
(:objects
    l1 l2 l3 l4 l5 l6 l7 - loc
    matteo alice francesco eliana giorgio - person
    f1 f2 f3 f4 - food
    m1 m2 m3 - meds
    carrier - carrier

    ;adding amount objects
    n1 n2 n3 n4 - amount
    bat_car1 bat_car2 bat_car3 bat_car4 bat_car5 bat_car6 bat_car7 bat_car8 bat_car9 bat_car10 - amount 
    bat_rob1 bat_rob2 bat_rob3 bat_rob4 bat_rob5 bat_rob6 bat_rob7 bat_rob8 bat_rob9 bat_rob10 - amount
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

    ;delivery state
    (not (is_delivered f1))
    (not (is_delivered f2))
    (not (is_delivered f3))
    (not (is_delivered f4))
    (not (is_delivered m1))
    (not (is_delivered m2))
    (not (is_delivered m3))


    ;robot location
    (robot_at operator depot)
    (is_empty operator)

    ;carrier location
    (carrier_at carrier depot)
    ;initialize carrier crate_count
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

    (pop n4 n3)
    (pop n3 n2)
    (pop n2 n1)
    (pop n1 n0)

    ;charge_battery and dec_battery
    (charge_battery_carrier bat_car0 bat_car10 carrier)
    (charge_battery_robot bat_rob bat_rob10 operator)

    (dec_battery_carrier bat_car10 bat_car9 carrier)
    (dec_battery_carrier bat_car9 bat_car8 carrier)
    (dec_battery_carrier bat_car8 bat_car7 carrier)
    (dec_battery_carrier bat_car7 bat_car6 carrier)
    (dec_battery_carrier bat_car6 bat_car5 carrier)
    (dec_battery_carrier bat_car5 bat_car4 carrier)
    (dec_battery_carrier bat_car4 bat_car3 carrier)
    (dec_battery_carrier bat_car3 bat_car2 carrier)
    (dec_battery_carrier bat_car2 bat_car1 carrier)
    (dec_battery_carrier bat_car1 bat_car0 carrier)
    
    (dec_battery_robot bat_rob10 bat_rob9 operator)
    (dec_battery_robot bat_rob9 bat_rob8 operator)
    (dec_battery_robot bat_rob8 bat_rob7 operator)
    (dec_battery_robot bat_rob7 bat_rob6 operator)
    (dec_battery_robot bat_rob6 bat_rob5 operator)
    (dec_battery_robot bat_rob5 bat_rob4 operator)
    (dec_battery_robot bat_rob4 bat_rob3 operator)
    (dec_battery_robot bat_rob3 bat_rob2 operator)
    (dec_battery_robot bat_rob2 bat_rob1 operator)
    (dec_battery_robot bat_rob1 bat_rob0 operator)
    
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
