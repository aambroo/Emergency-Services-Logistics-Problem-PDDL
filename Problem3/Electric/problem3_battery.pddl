(define (problem problem3_battery) (:domain durativeDelivery_battery)

(:objects
    l1 l2 l3 l4 l5 l6 l7 - location
    c1 c2 c3 c4 c5 c6 c7 - crate
    matteo alice francesco eliana giorgio - person
    meds food - content
    carrier - carrier

    ;adding amount objects
    n1 n2 n3 n4 - crate_amount
    bat_car1 bat_car2 bat_car3 bat_car4 bat_car5 bat_car6 bat_car7 bat_car8 bat_car9 bat_car10 - bat_amount
    bat_rob1 bat_rob2 bat_rob3 bat_rob4 bat_rob5 bat_rob6 bat_rob7 bat_rob8 bat_rob9 bat_rob10 - bat_amount
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

    ;add initial battery 
    ;(battery_level_carrier carrier bat_car10)
    ;(battery_level_robot operator bat_rob10)

    ;charge_battery and dec_battery
    ;(charge_battery_carrier bat_car0 bat_car10 carrier)
    ;(charge_battery_robot bat_rob0 bat_rob10 operator)

    (dec_battery_carrier bat_car10 bat_car8 carrier)
    (dec_battery_carrier bat_car8 bat_car6 carrier)
    (dec_battery_carrier bat_car6 bat_car4 carrier)
    (dec_battery_carrier bat_car4 bat_car2 carrier)
    (dec_battery_carrier bat_car2 bat_car0 carrier)
    
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

    ;TEST-ONLY
    (battery_level_carrier carrier bat_car6)
    (battery_level_robot operator bat_rob6)

    (charge_battery_carrier bat_car0 bat_car6 carrier)
    (charge_battery_robot bat_rob0 bat_rob6 operator)

    ;(dec_battery_robot bat_rob6 bat_rob4 operator)
    ;(dec_battery_robot bat_rob4 bat_rob2 operator)
    ;(dec_battery_robot bat_rob2 bat_rob0 operator)
    ;(dec_battery_carrier bat_car6 bat_car4 carrier)
    ;(dec_battery_carrier bat_car4 bat_car2 carrier)
    ;(dec_battery_carrier bat_car2 bat_car0 carrier)
    
    
)

(:goal (and
    
    ;Eliana needs food
    ;(or (served eliana f1)(served eliana f2)(served eliana f3)(served eliana f4))
    ;(exists (?c - food) (and (served eliana ?c)))
    (not_needs eliana food)


    
    ;Matteo needs 2 crates of meds
    ;(or (served matteo f1)(served matteo f2)(served matteo f3)(served matteo f4))
    ;(or (served matteo m1)(served matteo m2)(served matteo m3))
    ;(exists (?c - meds) (and (served matteo ?c)))
    

    ;Francesco needs both food and meds
    ;(or (served francesco m1)(served francesco m2)(served francesco m3))
    ;(or (served francesco m1)(served francesco m2)(served francesco m3))
    ;(exists (?c - meds) (and (served francesco ?c)))
    ;(exists (?c - food) (and (served francesco ?c)))
    (not_needs francesco food)(not_needs francesco food)

    ;Alice needs meds
    ;(or (served alice f1)(served alice f2)(served alice f3)(served alice f4))
    ;(exists (?c - meds) (and (served alice ?c)))
    (not_needs alice meds)
))

)
