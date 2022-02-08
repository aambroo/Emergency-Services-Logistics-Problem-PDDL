;PEOPLE might need food crates, meds crates, or both
;ROBOT can move between locations, can go back to base (depot) directly; 
;can load crates
;CRATES in depot are supposed to contain either food or meds; can be picked
;up and delivered by the ROBOT.

(define (domain basicDelivery)

;remove requirements that are not needed
(:requirements :typing :equality :negative-preconditions :disjunctive-preconditions)

(:types 
    robot - object
    crate - object
    person - object
    location - object
    food meds - crate
)

; un-comment following line if constants are needed
(:constants
    agent - robot
)

(:predicates 
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    (is_available ?c - crate)          ;crate can be loaded
    
    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    (is_empty ?r - robot)           ;robot ?r is empty
    (bearing ?r - robot ?c - crate)         ;robot ?r is bearing crate ?c
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    
    )

;moves robot between two locations: ?from and ?to
(:action move
    :parameters (?r - robot ?from ?to - location)
    :precondition (and 
        (robot_at ?r ?from)(not (= ?from ?to))
        )
    :effect (and 
        (robot_at ?r ?to)(not (robot_at ?r ?from))
        )
)


;load (generic) crate ?c onto robot ?r at location ?l
(:action load_crate
    :parameters (?l - location ?c - crate ?r - robot)
    :precondition (and 
        (robot_at ?r ?l)(is_empty ?r)
        (crate_at ?c ?l)(is_available ?c)
        (not (bearing ?r ?c))
        )
    :effect (and 
        (bearing ?r ?c)(not (is_empty ?r))
        (not (crate_at ?c ?l))
    )
)


;;deliver crate ?c to location ?l to person ?p
(:action deliver_food_crate
    :parameters (?r - robot ?c - crate ?l - location ?p - person ?f - need)
    :precondition (and 
        (robot_at ?r ?l)(person_at ?p ?l)
        (bearing ?r ?c)
        )
    :effect (and 
        (is_empty ?r)(food_served ?p)(crate_at ?c ?l)
        (not (bearing ?r ?c))(not (is_available ?c))
    )
)

;;deliver meds crate
(:action deliver_meds_crate
    :parameters (?r - robot ?c - crate ?l - location ?p - person)
    :precondition (and 
        (robot_at ?r ?l)(person_at ?p ?l)(bearing ?r ?c)
        )
    :effect (and 
        (is_empty ?r)(crate_at ?c ?l)
        (not (bearing ?r ?c))(not (needs_meds ?p))(not (is_available ?c))
    )
)


)