(define (domain normalDelivery)

;remove requirements that are not needed
(:requirements :typing :fluents :equality :negative-preconditions :disjunctive-preconditions)

(:types 
    robot - object
    carrier - object
    crate - object
    person - object
    base - location
    food meds - crate
)

(:constants
    operator - robot
    depot - base
)


(:predicates
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    (is_available ?c - crate)          ;crate can be loaded
    
    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    ;(is_empty ?r - robot)           ;robot ?r is empty
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    (served ?p - person ?c - crate)              ;person ?p has been served with crate ?c
    
    ;carrier
    (carrier_at ?k - carrier ?l - location)
    (bearing ?k - carrier ?c - crate)
)

;crate count function
(:functions
    (crate_count ?c - crate)
)



;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:action move
    :parameters (?r - robot ?k - carrier ?from ?to - location)
    :precondition (and 
        (robot_at ?r ?from)(carrier_at ?k ?from)
        (not (= ?from ?to))
        (>(crate_count ?k)0)
        )
    :effect (and 
        (robot_at ?r ?to)(carrier_at ?k ?to)
        (not (robot_at ?r ?from))(not (carrier_at ?k ?from))
        ;(increase (total_cost) 10)
        )
)

;send robot ?r and carrier ?k back to base (depot)
(:action back_to_base
    :parameters (?from - location ?to - warehouse ?r - robot ?k - carrier)
    :precondition (and 
        (carrier_at ?k ?from)(robot_at ?r ?from)
        (= (crate_count ?k) 0) ;this forces ?k and ?r to deliver crates first.
        )
    :effect (and 
        (robot_at ?r ?to)(carrier_at ?k ?to)
        (not (carrier_at ?k ?from))(not (robot_at ?r ?from))
        ;(increase (total_cost) 20)
        )
)

;load (generic) crate ?c onto robot ?r at location ?l
(:action load_crate
    :parameters (?depot - warehouse ?c - crate ?r - robot ?k - carrier)
    :precondition (and 
        (robot_at ?r ?depot)(carrier_at ?k ?depot)
        (crate_at ?c ?depot)(is_available ?c)
        (not (bearing ?k ?c))   ;crate must not be loaded yet
        (< (crate_count ?k) 4)  ;controls number of crates loaded
        )
    :effect (and 
        (bearing ?k ?c)(not (crate_at ?c ?depot))
        (increase (crate_count ?k) 1)   ;increases crate_count by 1 unit
        ;(increase (total_cost) 5)
    )
)


;;deliver (generic) crate ?c to location ?l to person ?p
(:action deliver_crate
    :parameters (?r - robot ?c - crate ?to - location ?p - person ?k - carrier)
    :precondition (and 
        (robot_at ?r ?to)(carrier_at ?k ?to)
        (person_at ?p ?to)(bearing ?k ?c)
        (not (served ?p ?c))
        (> (crate_count ?k) 0)  ;crate number must be non-negative nor nough for delivering
        )
    :effect (and 
        (served ?p ?c)(crate_at ?c ?to)
        (not (bearing ?k ?c))(not (is_available ?c))
        (decrease (crate_count ?k) 1)   ;decreases crate_count by 1 unit
        ;(increase (total_cost) 1)
    )
)

)