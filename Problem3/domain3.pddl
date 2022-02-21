;Header and description

(define (domain durativeDelivery)

;remove requirements that are not needed
;(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality ::disjunctive-preconditions)
(:requirements :strips :typing :durative-actions )

(:types 
    robot - object
    carrier - object
    crate - object
    person - object
    warehouse - location
    food meds - crate
)
; crate counter function --> removed because :fluent
;(:functions
;    (crate_count ?k - carrier)
;)
; un-comment following line if constants are needed
(:constants
    operator - robot
    depot - base
    init_num - amount
)
(:predicates 
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    (is_loaded ?c - crate)           ;crate unavailable because loaded 
    (is_delivered ?c - crate)                       ;crate unavailable because delivered

    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    (is_empty ?r - robot)           ;robot ?r is empty
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    (served ?p - person ?c - crate)              ;person ?p has been served with crate ?c

    ;carrier
    (carrier_at ?k - carrier ?l - location)
    (bearing ?k - carrier ?c - crate)         ;carrier ?k is bearing crate ?c

    ;predicates to avoid using fluents or ADLs
    ;add crate to crate_count
    (update ?init_amount ?final_amount - amount)
    ;pop crate to crate_count
    ;(pop ?orig_amount ?decrease - amount)
    ;differentiate crate_count per carrier
    (crate_count ?k - carrier ?num_crates - amount)
)


;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:durative-action move
    :parameters (?r - robot ?k - carrier ?from ?to - location)
    :duration (= ?duration 10)
    :condition (and 
        (at start (robot_at ?r ?from))
        (at start(carrier_at ?k ?from))
        ;(at start (not(=?from ?to)))           ;cannot use ADLs
        ;(at start (>(crate_count ?k)0))        ;cannot use ADLs
        (over all (is_empty ?r))                ;the robot cannot deliver while moving to a location 
    )
    :effect(and
        (at start (not(robot_at ?r ?from)))
        (at start(not(carrier_at ?k ?from)))
        (at end(robot_at ?r ?to))
        (at end(carrier_at ?k ?to))    
    )
)
;send robot ?r and carrier ?k back to base (depot)
(:durative-action back_to_base
    :parameters (?from - location ?depot - base ?r - robot ?k - carrier)
    :duration (= ?duration 10)
    :condition (and 
        (at start(robot_at ?r ?from))
        (at start (carrier_at ?k ?from))
        ;(at start (=(crate_count ?k)0)) ;cannot use ADLs
        (over all (is_empty ?r))        ;the robot cannot deliver while going back to base
        (at start (crate_count ?k init_num))      ;setting crate amount to init_num for carrier ?k
    )
    :effect(and
     (at start (not (robot_at ?r ?from)))
     (at start (not(carrier_at ?k ?from)))
     (at end (robot_at ?r ?depot))
     (at end (carrier_at ?k ?depot))
    )   
)
;load (generic) crate ?c onto robot ?r at location ?l
(:durative-action load_crate
    :parameters (?depot - base ?c - crate ?r - robot ?k - carrier ?init_amount ?final_amount - amount)
    :duration(= ?duration 5)
    :condition (and
        (at start (robot_at ?r ?depot))
        (at start (carrier_at ?k ?depot))
        (at start (crate_at ?c ?depot))
        (at start (not(is_loaded ?c)))
        (at start (not(is_delivered ?c)))
        (at start (not(bearing ?k ?c)))    ;crate must not be loaded yet
        ;(at start (<(crate_count ?k)4))   ;cannot use ADLs
        (at start (is_empty ?r))           ;prevent parallel actions
        (at start (update ?init_amount ?final_amount)) ;updating initial and final heaps, essential for counting crates
        
        (over all (crate_count ?k ?init_amount))    ;this prevents multiple robots to load multiple crates at a time
    
    )
    :effect (and
        (at start (not(is_empty ?r))) 
        (at end (not(is_loaded ?c)))         ;mainly set constant crate count
        (at end (bearing ?k ?c))
        (at end (not (crate_at ?c ?depot)))
        (at end (is_loaded ?c))
        ;(at end (increase (crate_count ?k) 1)) ;cannot use ADLs
        (at end (is_empty ?r))
        (at end (not (crate_count ?k ?init_amount)))
        (at end (crate_count ?k ?final_amount))
             
    )
)

;;deliver (generic) crate ?c to location ?l to person ?p
(:durative-action deliver_crate
    :parameters (?r - robot ?c - crate ?to - location ?p - person ?k - carrier ?init_amount ?final_amount - amount)
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot_at ?r ?to))
        (at start (carrier_at ?k ?to))
        (at start (person_at ?p ?to))
        (at start (is_loaded ?c))
        (at start (not(is_delivered ?c)))
        (at start (bearing ?k ?c))
        ;(at start (>(crate_count ?k)0))    ;cannot use ADLs
        (at start (update ?init_amount ?final_amount))
        (at start (is_empty ?r))

        (over all (crate_count ?k ?init_amount))    ;this prevents multiple robots to deliver multiple crates at a time
    )
    :effect (and
       (at start (not(is_empty ?r)))
       (at end (served ?p ?c))
       (at end (not(is_loaded ?c)))
       (at end (is_delivered ?c))
       (at end (not(bearing ?k ?c)))
       (at end (crate_at ?c ?to))
       ;(at end(decrease (crate_count ?k) 1))   ;cannot use ADLs
       (at end (not (crate_count ?k ?init_amount)))
       (at end (crate_count ?k ?final_amount))
       (at end (is_empty ?r))

    )
)
)