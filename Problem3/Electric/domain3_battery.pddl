;Header and description

(define (domain durativeDelivery_battery)


;remove requirements that are not needed
;(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality ::disjunctive-preconditions)
(:requirements :strips :typing :equality :negative-preconditions :durative-actions)

(:types 
    robot - object
    location - object
    carrier - object
    crate - object
    person - object
    loc base charge - location
    food meds - crate
    crate_amount bat_amount - counter
    counter - object
)

; un-comment following line if constants are needed
(:constants
    operator - robot
    depot - base
    n0 - crate_amount
    ;bat_car0 bat_rob0 - bat_amount
    bat_car0 bat_rob0 - bat_amount
    charging_station - charge
)

(:predicates 
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    (is_loaded ?c - crate)           ;crate unavailable because loaded 
    (is_delivered ?c - crate)                       ;crate unavailable because delivered
    (contains ?c - crate ?cont - content)       ;added as a result of OPTIC non-compatibility


    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    (is_empty ?r - robot)           ;robot ?r is empty
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    ;(served ?p - person ?c - crate)              ;person ?p has been served with crate ?c
    (needs ?p - person ?cont - content)            ;added as a result of OPTIC non-compatibility
    (not_needs ?p - person ?cont - content)

    ;carrier
    (carrier_at ?k - carrier ?l - location)
    (bearing ?k - carrier ?c - crate)         ;carrier ?k is bearing crate ?c

    ;predicates to avoid using fluents
    (add ?init_amount ?final_amount - crate_amount)
    (pop ?orig_amount ?final_amount - crate_amount)
    ;differentiate crate_count per carrier (in case there is more than one)
    (crate_count ?k - carrier ?num_crates - crate_amount)

    ;add forklift and carrier with battery
    (charge_battery_carrier ?init_car ?final_car - bat_amount ?k - carrier)
    (charge_battery_robot ?init_rob ?final_rob - bat_amount ?r - robot)

    (dec_battery_carrier ?origin_car ?final_car - bat_amount ?k - carrier)
    (dec_battery_robot ?origin_rob ?final_rob - bat_amount ?r - robot)

    (battery_level_carrier ?k - carrier ?battery_car - bat_amount)
    (battery_level_robot ?r - robot ?battery_rob - bat_amount) 


)


;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:durative-action move
    :parameters (?r - robot ?k - carrier ?from - location ?to - location ?origin_car ?final_car ?origin_rob ?final_rob - bat_amount)
    :duration (= ?duration 10)
    :condition (and 
        (at start (robot_at ?r ?from))
        (at start (carrier_at ?k ?from))
        ;(not(=?from ?to))           ;this way carrier is forced to pick action back_to_base to reload 
        (over all (is_empty ?r))
        (at start (not(battery_level_carrier ?k bat_car0)))            ;checking battey is NOT 0%
        (at start (not(battery_level_robot ?r bat_rob0)))              ;checking battey is NOT 0%
        
        (at start (dec_battery_carrier ?origin_car ?final_car ?k))
        (at start (battery_level_carrier ?k ?origin_car))
        (at start (dec_battery_robot ?origin_rob ?final_rob ?r))
        (at start (battery_level_robot ?r ?origin_rob))                 ;NOT SURE ABOUT THIS
        
    )
    :effect(and
        (at start (not(robot_at ?r ?from)))
        (at end (robot_at ?r ?to))
        (at start (not(carrier_at ?k ?from)))
        (at end (carrier_at ?k ?to))
          
        (at end (not(battery_level_carrier ?k ?origin_car)))
        (at end (battery_level_carrier ?k ?final_car))
        (at end (not(battery_level_robot ?r ?origin_rob)))
        (at end (battery_level_robot ?r ?final_rob))
    )
)
;send robot ?r and carrier ?k back to base (depot)
(:durative-action back_to_base
    :parameters (?from - loc ?to - base ?r - robot ?k - carrier)
    :duration (= ?duration 15)
    :condition (and 
        (at start (robot_at ?r ?from))
        (at start (carrier_at ?k ?from))
        (over all (is_empty ?r))
        (at start (crate_count ?k n0))            ;carrier cannot take cut-off unless empty
        
        
    )
    :effect(and
        (at start (not (robot_at ?r ?from)))
        (at start (not (carrier_at ?k ?from)))
        (at end (robot_at ?r ?to))
        (at end (carrier_at ?k ?to))

    )   
)

(:durative-action back_to_charging_station
    :parameters (?r - robot ?k - carrier ?from - location) ;?origin_car ?final_car ?origin_rob ?final_rob - amount)
    :duration (= ?duration 1)
    :condition (and 
        ;(at start (or (battery_level_carrier ?k bat_car0)(battery_level_robot ?r bat_rob0)))
        (at start (battery_level_carrier ?k bat_car0))
        ;(battery_level_robot ?r bat_rob0)
        (at start (robot_at ?r ?from))
        (at start (carrier_at ?k ?from))
        ;DONT TOUCH
        ;(dec_battery_carrier ?origin_car ?final_car ?k)
        ;(dec_battery_robot ?origin_rob ?final_rob ?r)
    )

    :effect (and
        (at start (not(robot_at ?r ?from)))
        (at start (not(carrier_at ?k ?from)))
        (at end (robot_at ?r charging_station))
        (at end (carrier_at ?k charging_station))
        ;DONT TOUCH
        ;(not(battery_level_carrier ?k ?origin_car))
        ;(not(battery_level_robot ?r ?origin_rob))
        ;(battery_level_carrier ?k ?final_car)
        ;(battery_level_robot ?r ?final_rob) 
    )
)

;load (generic) crate ?c onto robot ?r at location ?l
(:durative-action load_crate
    :parameters (?depot - base ?c - crate ?r - robot ?k - carrier ?init_amount ?final_amount - crate_amount ?origin_rob ?final_rob - bat_amount)
    :duration (= ?duration 1)
    :condition (and
        (at start (robot_at ?r ?depot))
        (at start (carrier_at ?k ?depot))
        (at start (crate_at ?c ?depot))
        ;(at start (not (bearing ?k ?c)))
        ;(at start (not (is_delivered ?c)))
        ;(at start (not (battery_level_carrier ?k bat_car0)))       ;checking battey is NOT 0%
        (at start (not (battery_level_robot ?r bat_rob0)))         ;checking battey is NOT 0%
        
        ;tracking crate count
        (at start (is_empty ?r))
        (at start (add ?init_amount ?final_amount))                ;updating initial and final heaps, essential for counting crates
        (over all (crate_count ?k ?init_amount))                   ;this prevents multiple robots to load multiple crates at a time
        
        ;tracking battery life
        (at start (dec_battery_robot ?origin_rob ?final_rob ?r))   ;updates battery discharge for load task
        (at start (battery_level_robot ?r ?origin_rob))            ;NOT SURE ABOUT THIS

    )
    :effect (and
        (at start (not (is_empty ?r)))
        (at start (not (is_loaded ?c)))
        (at end (bearing ?k ?c))
        (at end (not (crate_at ?c ?depot)))
        (at end (is_empty ?r))
        (at end (is_loaded ?c))
        
        (at end (not (crate_count ?k ?init_amount)))
        (at end (crate_count ?k ?final_amount))
        
        (at end (not (battery_level_robot ?r ?origin_rob)))
        (at end (battery_level_robot ?r ?final_rob))
             
    )
)

;;deliver (generic) crate ?c to location ?l to person ?p
(:durative-action deliver_crate
    :parameters (?r - robot ?c - crate ?cont - content ?to - loc ?p - person ?k - carrier ?init_amount ?final_amount - crate_amount ?origin_rob ?final_rob - bat_amount)
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot_at ?r ?to))
        (at start (carrier_at ?k ?to))
        (at start (person_at ?p ?to))
        (at start (needs ?p ?cont))
        (at start (is_loaded ?c))
        (at start (contains ?c ?cont))
        ;((not (is_delivered ?c))
        (at start (bearing ?k ?c))
        (at start (pop ?init_amount ?final_amount))
        (over all (crate_count ?k ?init_amount))                    ;this prevents multiple robots to deliver multiple crates at a time
        
        ;((not (battery_level_robot ?r bat_rob0)))                  ;checking battery is NOT 0%
        (at start (dec_battery_robot ?origin_rob ?final_rob ?r))    ;updates battery discharge for delivery task
        (over all (battery_level_robot ?r ?origin_rob))             ;NOT SURE ABOUT THIS
    )
    :effect (and
       (at start (not(is_empty ?r)))
       (at start (not (needs ?p ?cont)))
       (at end (not_needs ?p ?cont))
       (at end (not(is_loaded ?c)))
       (at end (is_delivered ?c))
       (at end (not(bearing ?k ?c)))
       (at end (crate_at ?c ?to))
       (at end (not (crate_count ?k ?init_amount)))
       (at end (crate_count ?k ?final_amount))
       (at end (is_empty ?r))

       (at end (not (battery_level_robot ?r ?origin_rob)))
       (at end (battery_level_robot ?r ?final_rob))

    )
)
(:durative-action charge_battery
    :parameters (?charge - charge ?r - robot ?k - carrier ?init_car ?final_car ?init_rob ?final_rob - bat_amount)
    :duration (= ?duration 15)
    :condition (and 
        (at start (carrier_at ?k ?charge))
        (at start (robot_at ?r ?charge))
        
        (at start (charge_battery_carrier ?init_car ?final_car ?k))
        (at start (battery_level_carrier ?k ?init_car))
        
        (at start (charge_battery_robot ?init_rob ?final_rob ?r))
        (at start (battery_level_robot ?r ?init_rob))
    )
    :effect (and 
        (at end (carrier_at ?k ?charge))
        (at end (robot_at ?r ?charge))
        (at end (not(battery_level_carrier ?k ?init_car)))
        (at end (battery_level_carrier ?k ?final_car))
        (at end (not(battery_level_robot ?r ?init_rob)))
        (at end (battery_level_robot ?r ?final_rob))
    )   
)


)