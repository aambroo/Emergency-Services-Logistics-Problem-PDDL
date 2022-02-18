;Header and description

(define (domain durativeDelivery)

;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

(:types 
    robot - object
    carrier - object
    crate - object
    person - object
    warehouse - location
    food meds - crate
)
; crate counter function
(:functions
    (crate_count ?k - carrier)
)
; un-comment following line if constants are needed
(:constants
    operator - robot
    depot - warehouse
)
(:predicates 
    ;crates
    (crate_at ?c - crate ?l - location)     ;crate ?c crate_at at location ?l
    (is_available ?c - crate)          ;crate can be loaded. A crate becomes unavailable whenever it gets delivered to a person.
    
    ;robot
    (robot_at ?r - robot ?l - location)     ;robot ?r is at location ?l
    (is_empty ?r - robot)           ;robot ?r is empty
    
    ;people
    (person_at ?p - person ?l - location)       ;person ?p is at location ?l
    (served ?p - person ?c - crate)              ;person ?p has been served with crate ?c

    ;carrier
    (carrier_at ?k - carrier ?l - location)
    (bearing ?k - carrier ?c - crate)         ;carrier ?k is bearing crate ?c
)


;moves robot between two locations: ?from and ?to
;NOTE: crates of no kind are involved
(:durative-action move
    :parameters (?r - robot ?k - carrier ?from ?to - location)
    :duration (= ?duration 10)
    :condition (and 
        (at start (robot_at ?r ?from))
        (at start(carrier_at ?k ?from))
        (at start (not(=?from ?to)))
        (at start (>(crate_count ?k)0))      
    )
    :effect(and
        (at start (>(crate_count ?k)0))
        (at start (not(robot_at ?r ?from)))
        (at start(not(carrier_at ?k ?from)))
        (at end(robot_at ?r ?to))
        (at end(carrier_at ?k ?to))    
    )
)
;send robot ?r and carrier ?k back to base (depot)
(:durative-action back_to_base
    :parameters (?from - location ?to - warehouse ?r - robot ?k - carrier)
    :duration (= ?duration 10)
    :condition (and 
        (at start(robot_at ?r ?from))
        (at start (carrier_at ?k ?from))
        (at start (=(crate_count ?k)0)) ;this forces ?k and ?r to deliver crates first.
    )
    :effect(and
     (at start (not (robot_at ?r ?from)))
     (at start (not(carrier_at ?k ?from)))
    ; (at start (not(=(crate_count ?k)0)))               ;controllare
     (at end (robot_at ?r ?to))
     (at end (carrier_at ?k ?to))
    )   
)
;load (generic) crate ?c onto robot ?r at location ?l
(:durative-actions load_crate
    :parameters (?depot - warehouse ?c - crate ?r - robot ?k - carrier)
    :duration(= ?duration 5)
    :condition (and
        (at start (robot_at ?r ?depot))
        (at start (carrier_at ?k ?depot))
        (at start (crate_at ?c ?depot))
        (at start (is_available ?c))
        (at start (not(bearing ?k ?c)))    ;crate must not be loaded yet
        (at start (<(crate_count ?k)4))    ;controls number of crates loaded
    )
    :effect (and
        (at start (not(is_available ?c)))   ; controllareee!!!!!!!!!!!!!
        (at start(bearing ?k ?c))
        (at start (not (crate_at ?c ?depot)))
        (at end(increase (crate_count ?k) 1))
    )
)

;;deliver (generic) crate ?c to location ?l to person ?p
(:durative-action deliver_crate
    :parameters (?r - robot ?c - crate ?to - location ?p - person ?k - carrier)
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot_at ?r ?to))
        (at start (carrier_at ?k ?to))
        (at start (person_at ?p ?to))
        (at start (bearing ?k ?c))
        (at start (>(crate_count ?k)0))
    )
    :effect (and
       (at end (served ?p ?c))
       (at end (not(is_available ?c)))
       (at end(decrease (crate_count ?k) 1))
       (at start (not(bearing ?k ?c)))
       (at end (crate_at ?c ?to))
    )

)



