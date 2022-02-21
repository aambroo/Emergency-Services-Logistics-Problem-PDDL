;Header and description

(define (domain normalDelivery_no_fluents)

;remove requirements that are not needed
;(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality ::disjunctive-preconditions)
(:requirements :typing :equality :negative-preconditions :disjunctive-preconditions)

(:types 
    robot - object
    location - object
    carrier - object
    crate - object
    person - object
    loc base - location
    food meds - crate
    amount - object
)
; crate counter function --> removed because :fluent
;(:functions
;    (crate_count ?k - carrier)
;)
; un-comment following line if constants are needed
(:constants
    operator - robot
    depot - base
    n0 - amount
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
)


;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:action move
    :parameters (?r - robot ?k - carrier ?from - location ?to - loc )
    :precondition (and 
        (robot_at ?r ?from)
        (carrier_at ?k ?from)
        (not(=?from ?to))           ;this way carrier is forced to pick action back_to_base to reload 
    )
    :effect(and
        (not(robot_at ?r ?from))
        (not(carrier_at ?k ?from))
        (robot_at ?r ?to)
        (carrier_at ?k ?to)    
    )
)
;send robot ?r and carrier ?k back to base (depot)
(:action back_to_base
    :parameters (?from - loc ?to - base ?r - robot ?k - carrier)
    :precondition (and 
        (robot_at ?r ?from)
        (carrier_at ?k ?from)
        ;(at start (=(crate_count ?k)0)) ;cannot use ADLs
        (crate_count ?k n0)      ;setting crate amount to initial number (n0) for carrier ?k
    )
    :effect(and
        (not (robot_at ?r ?from))
        (not (carrier_at ?k ?from))
        (robot_at ?r ?to)
        (carrier_at ?k ?to)
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
        ;(is_loaded ?c)
        ;(contains ?c ?cont)
        ;(at start (not(is_delivered ?c)))
        (bearing ?k ?c)
        ;(at start (>(crate_count ?k)0))    ;cannot use ADLs
        (pop ?init_amount ?final_amount)
        (crate_count ?k ?init_amount)    ;this prevents multiple robots to deliver multiple crates at a time
    )
    :effect (and
       ;(not(is_loaded ?c))
       (is_delivered ?c)
       (served ?p ?c)
       (not(bearing ?k ?c))
       (crate_at ?c ?to)
       (not (crate_count ?k ?init_amount))
       (crate_count ?k ?final_amount)

    )
)
)