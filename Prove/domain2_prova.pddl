;PEOPLE might need food crates, meds crates, or both
;ROBOT can move between locations, can go back to base (depot) directly; 
;can load crates
;CRATES in depot are supposed to contain either food or meds; can be picked
;up and delivered by the ROBOT.
;In this example crates are moved in a different way wrt domain1

(define (domain normalDelivery_prova)

;remove requirements that are not needed
(:requirements :typing :fluents :adl)

(:types 
    robot       ;fixed at depot. Loads the carrier.
    carrier     ;is loaded by the robot. Delivers crates to people in need.
    crate       ;a crate can contain food or meds. Can be loaded from a robot onto
                ;a carrier.
    person      ;a person
    location    ;place where to deliver crates. People can be at locations.
    count       ;number of crates per carrier
    capacity
    ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
)

; un-comment following line if constants are needed
(:constants
    depot - location
    meds food - content
)


(:predicates 
    ;crates
    (contains ?c - crate ?content - content)         ;crate ?c contains ?content
    (lays ?c - crate ?l - location)         ;crate ?c lays at location ?l
    (is_available ?c - crate)                   ;crate can be loaded
    ;robot
    (is_empty ?r - robot)                   ;robot ?r is empty
    (is_holding ?r - robot ?c - crate)
    ;carrier
    (is_at_loc ?carrier - carrier ?l - location)    ;robot ?r is at location ?l
    (carrier_capacity ?capacity - capacity)                           ;counts number of crates loaded in robot
    (is_carrying ?carrier - carrier ?c - crate)       ;robot ?r is loaded with crate ?c
    ;people
    (is_at ?p - person ?l - location)       ;person ?p is at location ?l
    (needs_food ?p - person)                ;person ?p needs food
    (needs_meds ?p - person)                ;person ?p needs meds
    ;satisfaction
    (food_served ?p - person)                 ;person ?p has been served
    (meds_served ?p - person)                 ;person ?p has been served

    )


(:functions
    (total_cost)
    (carrier_counter ?carrier - carrier)
)

;;move robot from location ?l1 to location ?l2
;;where l1 --> initial loc ; l2 --> arrival loc
(:action move
    :parameters (?r - robot ?l1 ?l2 - location)
    :precondition (and (is_at_loc ?r ?l1))
    :effect (and (is_at_loc ?r ?l2)(not (is_at_loc ?r ?l1)))
)

;;send robot back to base (depot)
;(:action back_to_base
;    :parameters (?l ?depot - location ?r - robot)
;    :precondition (and (is_at_loc ?r ?l))
;    :effect (and (is_at_loc ?r ?depot)(not (is_at_loc ?r ?l)))
;)

;;robot loads meds crate onto carrier
(:action load_meds_crate
    :parameters (?l - location ?c - crate ?r - robot ?carrier - carrier ?crate_count - count)
    :precondition (and 
        (is_empty ?r)
        (lays ?c ?l)(is_available ?c)
        (is_at_loc ?carrier ?l)
        )
    :effect (and (is_loaded ?r ?c)(not (is_empty ?r))
        (not (lays ?c ?l))
    )
)

;;robot loads meds crate onto carrier
(:action load_meds_crate
    :parameters (?c - crate ?carrier - carrier ?capacity - capacity ?r - robot )
    :precondition (and 
        (lays ?c depot)(contains ?c meds)
        (is_at_loc ?carrier depot)            ;;MANCA CONTROLLO QUANTITÀ
        (is_empty ?r)
        (>= (- (carrier_capacity ?capacity) (carrier_counter ?carrier)) 0)
    )
    :effect (and )
)


;;loads food crate
(:action load_food_crate
    :parameters (?l - location ?c - crate ?r - robot)
    :precondition (and (is_at_loc ?r ?l)(is_empty ?r)(lays ?c ?l)(is_available ?c))
    :effect (and (is_loaded ?r ?c)(not (is_empty ?r))
        (not (lays ?c ?l))
    )
)

;;deliver food crate
(:action deliver_food_crate
    :parameters (?r - robot ?c - crate ?l - location ?p - person)
    :precondition (and 
        (is_at_loc ?r ?l)(is_at ?p ?l)(is_loaded ?r ?c)(needs_food ?p)
        )
    :effect (and 
        (is_empty ?r)(food_served ?p)(lays ?c ?l)
        (not (is_loaded ?r ?c))(not (needs_food ?p))(not (is_available ?c))
    )
)

;;deliver meds crate
(:action deliver_meds_crate
    :parameters (?r - robot ?c - crate ?l - location ?p - person)
    :precondition (and 
        (is_at_loc ?r ?l)(is_at ?p ?l)(is_loaded ?r ?c)(needs_meds ?p)
        )
    :effect (and 
        (is_empty ?r)(meds_served ?p)(lays ?c ?l)
        (not (is_loaded ?r ?c))(not (needs_meds ?p))(not (is_available ?c))
    )
)


)