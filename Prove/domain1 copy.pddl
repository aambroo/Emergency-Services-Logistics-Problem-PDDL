;PEOPLE might need food crates, meds crates, or both
;ROBOT can move between locations, can go back to base (depot) directly; 
;can load crates
;CRATES in depot are supposed to contain either food or meds; can be picked
;up and delivered by the ROBOT.

(define (domain basicDelivery_copy)

;remove requirements that are not needed
(:requirements :typing)

(:types 
    robot crate person location carrier content
    ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    depot - location
    food meds - content
)

(:predicates 
    ;crates
    (contains ?c - crate ?content - content)      ;crate ?c contains 
    (lays ?c - crate ?l - location)         ;crate ?c lays at location ?l
    (is_available ?c - crate)                   ;crate can be loaded
    
    ;robot (static)
    (is_holding ?c - crate)
    (is_free ?r)

    ;carrier (dynamic)
    (is_at_loc ?carrier - carrier ?l - location)    ;carrier ?r is at location ?l
    (is_empty ?carrier - carrier)                   ;carrier ?r is empty
    (is_loaded ?carrier - carrier ?c - crate)       ;carrier ?r is loaded with crate ?c
    
    ;people
    (is_at ?p - person ?l - location)       ;person ?p is at location ?l
    ;needs
    (needs ?p - person ?content - content)      ;person p needs ?content 
    (needs_food ?p - person)                ;person ?p needs food
    (needs_meds ?p - person)                ;person ?p needs meds
    ;satisfaction
    (served ?p - person ?content - content)
    (food_served ?p - person)                 ;person ?p has been served
    (meds_served ?p - person)                 ;person ?p has been served

    )


(:functions ;todo: define numeric functions here
)

;;move carrier from location ?l1 to location ?l2
;;where l1 --> initial loc ; l2 --> arrival loc
(:action move
    :parameters (?carrier - carrier ?r - robot ?from ?to - location)
    :precondition (and (is_at_loc ?carrier ?from))
    :effect (and (is_at_loc ?carrier ?to)(not (is_at_loc ?carrier ?from)))
)

;;send robot back to base (depot)
;(:action back_to_base
;    :parameters (?l ?depot - location ?r - robot)
;    :precondition (and (is_at_loc ?r ?l))
;    :effect (and (is_at_loc ?r ?depot)(not (is_at_loc ?r ?l)))
;)

;;loads crate
(:action load_crate
    :parameters (?depot - location ?c - crate ?r - robot ?carrier - carrier ?content - content)
    :precondition (and 
        (is_at_loc ?carrier ?depot)(is_empty ?carrier)(lays ?c ?depot)
        (is_available ?c)(contains ?c ?content))
    :effect (and (is_loaded ?carrier ?c)(not (is_empty ?carrier))
        (not (lays ?c ?depot))
    )
)

;;deliver crate
(:action deliver_crate
    :parameters (?r - robot ?c - crate ?l - location ?p - person ?carrier - carrier ?content - content)
    :precondition (and 
        (is_at_loc ?carrier ?l)(is_at ?p ?l)(is_loaded ?carrier ?c)(needs ?p ?content)
        )
    :effect (and 
        (is_empty ?carrier)(served ?p ?content)(lays ?c ?l)
        (not (is_loaded ?carrier ?c))(not (needs ?p ?content))(not (is_available ?c))
    )
)


)