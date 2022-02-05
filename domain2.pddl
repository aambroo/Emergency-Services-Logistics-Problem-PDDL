;Header and description

(define (domain normalDelivery)

;remove requirements that are not needed
(:requirements :typing :fluents :equality)

(:types
    location
    robot
    carrier
    crate
    person
)

(:constants
    depot - location
    food meds - amenity
)

(:predicates 
    (is_at_loc ?carrier - carrier ?l - location)
    (carrier_counter ?carrier)
    (is_carrying ?carrier - carrier ?c - crate)

    (lays ?c - crate ?l - location)

    (needs ?p - person ?a - amenity)
    (is_at ?p - parson ?l - location)
)


(:functions 
    (total_cost)
)

;;carrier cruises from location ?from to location ?to
(:action cruise
    :parameters (?from ?to - location ?r - robot ?carrier - carrier)
    :precondition (and 
            (not (= ?from ?to))(is_at_loc ?carrier ?from)
        )
    :effect (and 
            (not (is_at_loc ?carrier ?from))(is_at_loc ?carrier ?to)
    )
)

;;robot loads crate onto carrier
(:action load_carrier
    :parameters (?carrier - carrier ?c - crate ?depot - location)
    :precondition (and
        (is_at_loc ?carrier ?depot)(lays ?c ?depot)
    )
    :effect (and
        (is_carrying ?carrier ?c)
    )
)

;;carrier delivers crate
(:action deliver_crate
    :parameters (?carrier - carrier ?c - crate ?l - location ?p - person ?a - amenity)
    :precondition (and
        (is_at ?p ?l)(needs ?p ?a)
    )
    :effect (and
        (is_carrying ?carrier ?c)
    )
)
)