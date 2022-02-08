;Header and description

(define (domain classical_planning)

;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

(:types 
    robot - robot
    room - location
    box
    switch
    location
)

; un-comment following line if constants are needed
;(:constants )

(:predicates
    (at ?shakey - robot ?x - location)
    (on ?shakey - robot ?box - box)
    (at_loc ?box - box ?x - location)
    (at_location ?switch - switch ?x - location)
    (turned_on ?switch - switch)
    (in ?x ?y - location ?room - room)
)


(:functions ;todo: define numeric functions here
)

(:action go
    :parameters (?x ?y - location ?shakey - robot ?room - room)
    :precondition (and 
        (at ?shakey ?x)(in ?x ?y ?room)
    )
    :effect (and 
        (at ?shakey ?y)(not (at ?shakey ?x))
    )
)

(:action push
    :parameters (?x ?y - location ?box - box ?room - room ?shakey - robot)
    :precondition (and 
        (in ?x ?y ?room)(at_loc ?box ?x)(at ?shakey ?x)
    )
    :effect (and 
        (at_loc ?box ?y)(at ?shakey ?y)
        (not (at_loc ?box ?x))(not (at ?shakey ?x))
    )
)

(:action turn_on
    :parameters (?switch - switch ?x - location ?shakey - robot ?box - box)
    :precondition (and 
        (on ?shakey ?box)(at_loc ?box ?x)(at_location ?switch ?x)
    )
    :effect (and 
        (turned_on ?switch)
    )
)

(:action turn_off
    :parameters (?switch - switch ?x - location ?shakey - robot ?box - box)
    :precondition (and 
        (on ?shakey ?box)(at_loc ?box ?x)(at_location ?switch ?x)
    )
    :effect (and 
        (not (turned_on ?switch))
    )
)
)