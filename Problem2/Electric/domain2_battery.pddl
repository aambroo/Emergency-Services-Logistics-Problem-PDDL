;Header and description

(define (domain normalDelivery_battery)

;remove requirements that are not needed
;(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality ::disjunctive-preconditions)
(:requirements :typing :equality :negative-preconditions :disjunctive-preconditions)

(:types 
    robot - object
    location - object
    carrier - object
    crate - object
    person - object
    loc base charge - location
    food meds - crate
    amount - object
)

; un-comment following line if constants are needed
(:constants
    operator - robot
    depot - base
    n0 - amount
    bat_car1 bat_rob1 - amount
    bat_car0 bat_rob0 - amount
    charge - charge
)

(:predicates 
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    ;(is_loaded ?c - crate)           ;crate unavailable because loaded 
    (is_delivered ?c - crate)                       ;crate unavailable because delivered

    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    (is_empty ?r - robot)           ;robot ?r is empty
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    (served ?p - person ?c - crate)              ;person ?p has been served with crate ?c
    ;(needs ?p - person ?cont - content)            ;added as a result of OPTIC non-compatibility
    ;(not_needs ?p - person ?cont - content)

    ;carrier
    (carrier_at ?k - carrier ?l - location)
    (bearing ?k - carrier ?c - crate)         ;carrier ?k is bearing crate ?c

    ;predicates to avoid using fluents
    (add ?init_amount ?final_amount - amount)
    (pop ?orig_amount ?final_amount - amount)
    ;differentiate crate_count per carrier
    (crate_count ?k - carrier ?num_crates - amount)

    ;add forklift and carrier with battery
    (charge_battery_carrier ?init_car ?final_car - amount ?k - carrier)
    (charge_battery_robot ?init_rob ?final_rob - amount ?r - robot)

    (dec_battery_carrier ?origin_car ?fine_car - amount ?k - carrier)
    (dec_battery_robot ?origin_rob ?fine_rob - amount ?r - robot)

    (battery_level_carrier ?k - carrier ?battery_car - amount)
    (battery_level_robot ?r - robot ?battery_rob - amount) 


)


;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:action move
    :parameters (?r - robot ?k - carrier ?from - location ?to - location ?origin_car ?fine_car ?origin_rob ?fine_rob - amount)
    :precondition (and 
        (robot_at ?r ?from)
        (carrier_at ?k ?from)
        (not(=?from ?to))           ;this way carrier is forced to pick action back_to_base to reload 
        ;(not(battery_level_carrier ?k bat_car0))       ;CHECK    -> stessa cosa con or
        ;(not(battery_level_robot ?r bat_rob0))         ; CHECK
        (dec_battery_carrier ?origin_car ?fine_car ?k)
        (dec_battery_robot ?origin_rob ?fine_rob ?r)
    )
    :effect(and
        (not(robot_at ?r ?from))
        (not(carrier_at ?k ?from))
        (robot_at ?r ?to)
        (carrier_at ?k ?to) 
          
        ;(not(battery_level_carrier ?k ?origin_car))
        ;(not(battery_level_robot ?r ?origin_rob))
        (battery_level_carrier ?k ?fine_car) 
        (battery_level_robot ?r ?fine_rob)   
    )
)
;send robot ?r and carrier ?k back to base (depot)
(:action back_to_base
    :parameters (?from - loc ?to - base ?r - robot ?k - carrier)
    :precondition (and 
        (robot_at ?r ?from)
        (carrier_at ?k ?from)
        (crate_count ?k n0)                              ;setting crate amount to initial number (n0) for carrier ?k
        
    )
    :effect(and
        (not (robot_at ?r ?from))
        (not (carrier_at ?k ?from))
        (robot_at ?r ?to)
        (carrier_at ?k ?to)

    )   
)

(:action back_charge
    :parameters (?r - robot ?k - carrier ?charge_loc - charge ?from - location ?origin_car ?fine_car ?origin_rob ?fine_rob - amount)
    :precondition (and 
        (battery_level_carrier ?k bat_car1)             ; check : meglio mettere or? perchè può essere che robot sia scarico ma il carrier no !!!!!!!!!!!!!!
        (battery_level_robot ?r bat_rob1)
        (robot_at ?r ?from)
        (carrier_at ?k ?from)
        (dec_battery_carrier ?origin_car ?fine_car ?k)
        (dec_battery_robot ?origin_rob ?fine_rob ?r)
    )

    :effect (and
        (robot_at ?r ?charge_loc)
        (carrier_at ?k ?charge_loc)
        (not(robot_at ?r ?from))
        (not(carrier_at ?k ?from))
        
        (not(battery_level_carrier ?k ?origin_car))
        (not(battery_level_robot ?r ?origin_rob))
        (battery_level_carrier ?k ?fine_car)
        (battery_level_robot ?r ?fine_rob) 
    )
)

;load (generic) crate ?c onto robot ?r at location ?l
(:action load_crate
    :parameters (?depot - base ?c - crate ?r - robot ?k - carrier ?init_amount ?final_amount - amount)
    :precondition (and
        (robot_at ?r ?depot)
        (carrier_at ?k ?depot)
        (crate_at ?c ?depot)
        (add ?init_amount ?final_amount) ;updating initial and final heaps, essential for counting crates
        (not (bearing ?k ?c))
        (not (is_delivered ?c))
        (crate_count ?k ?init_amount)    ;this prevents multiple robots to load multiple crates at a time

    )
    :effect (and
        (bearing ?k ?c)
        (not (crate_at ?c ?depot))
        (is_empty ?r)
        (not (crate_count ?k ?init_amount))
        (crate_count ?k ?final_amount)
             
    )
)

;;deliver (generic) crate ?c to location ?l to person ?p
(:action deliver_crate
    :parameters (?r - robot ?c - crate ?to - loc ?p - person ?k - carrier ?init_amount ?final_amount - amount)
    :precondition (and 
        (robot_at ?r ?to)
        (carrier_at ?k ?to)
        (person_at ?p ?to)
        (not (is_delivered ?c))
        (bearing ?k ?c)
        (pop ?init_amount ?final_amount)
        (crate_count ?k ?init_amount)    ;this prevents multiple robots to deliver multiple crates at a time
    )
    :effect (and
       (is_delivered ?c)
       (served ?p ?c)
       (not(bearing ?k ?c))
       (crate_at ?c ?to)
       (not (crate_count ?k ?init_amount))
       (crate_count ?k ?final_amount)

    )
)
(:action charge_battery
    :parameters (?charge - charge ?r - robot ?k - carrier ?init_car ?init_rob ?final_car ?final_rob - amount)
    :precondition (and 
        (carrier_at ?k ?charge)
        (robot_at ?r ?charge)
        (battery_level_carrier ?k ?init_car)
        (battery_level_robot ?r ?init_rob)
        (charge_battery_carrier ?init_car ?final_car ?k)
        (charge_battery_robot ?init_rob ?final_rob ?r)
    )
    :effect (and 
        (carrier_at ?k ?charge)
        (robot_at ?r ?charge)
        (not(battery_level_carrier ?k ?init_car))
        (not(battery_level_robot ?r ?init_rob))
        (battery_level_carrier ?k ?final_car)
        (battery_level_robot ?r ?final_rob)
    )   
)


)