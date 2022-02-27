(define (domain dynamic_delivery)
    (:requirements :strips :typing :durative-actions)
    (:types
        robot - object
        carrier - object
        crate - object
        person - object
        location - object
        content - object
        amount - object
        loc base - location
        is0 - amount
        non0 - amount
    )

    (:predicates
        ; crates
        (crate_at ?c - crate ?l - location)
        (delivered_to ?p - person ?c - crate)
        (contains ?c - crate ?cont - content)

        ; robot
        (robot_at ?r - robot ?l - location)
        (is_empty ?r - robot)

        ; people
        (person_at ?p - person ?l - location)
        (needs ?p - person ?cont - content)
        (not_needs ?p - person ?cont - content)

        ; carrier
        (carrier_at ?k - carrier ?l - location)
        (bearing ?k - carrier ?c - crate) 


        (add ?init_amount ?final_amount - amount) 
        (pop ?orig_amount ?final_amount - amount) 
        (crate_count ?k - carrier ?q - amount) 
    )


    (:durative-action move
        :parameters (?r - robot ?k - carrier ?from - location ?to - loc ?nnon - non0)
        :duration ( = ?duration 10)
        :condition (and 
            (at start (robot_at ?r ?from))
            (at start (carrier_at ?k ?from))
            (over all (is_empty ?r))
            
            (over all (crate_count ?k ?nnon))
        )
        :effect (and 
            (at start (not (robot_at ?r ?from)))
            (at start (not (carrier_at ?k ?from)))
            (at end (robot_at ?r ?to))
            (at end (carrier_at ?k ?to))
        )
    )


    (:durative-action back_to_base
        :parameters (?r - robot ?k - carrier ?from - loc ?depot - base ?zero - is0)
        :duration ( = ?duration 10)
        :condition (and 
            (at start (robot_at ?r ?from))
            (at start (carrier_at ?k ?from))
            (over all (is_empty ?r))
            (at start (crate_count ?k ?zero))
        )
        :effect (and 
            (at start (not (robot_at ?r ?from)))
            (at start (not (carrier_at ?k ?from)))
            (at end (robot_at ?r ?depot))
            (at end (carrier_at ?k ?depot))
        )
    )

    
    (:durative-action load_crate
        :parameters (?r - robot ?k - carrier ?c - crate ?depot - base ?init_amount ?final_amount - amount)
        :duration ( = ?duration 5)
        :condition (and 
            (at start (robot_at ?r ?depot))
            (at start (carrier_at ?k ?depot))
            (at start (crate_at ?c ?depot))
            (at start (add ?init_amount ?final_amount))
            (at start (crate_count ?k ?init_amount))
            (at start (is_empty ?r))

            (over all (crate_count ?k ?init_amount))
        )
        :effect (and 
            (at start (not (is_empty ?r)))
            (at end (not (crate_at ?c ?depot)))
            (at end (bearing ?k ?c))
            (at end (crate_count ?k ?final_amount))
            (at end (not (crate_count ?k ?init_amount)))
            (at end (is_empty ?r))
        )
    )


    (:durative-action deliver_crate
        :parameters (?r - robot ?k - carrier ?c - crate ?cont - content ?p - person ?l - loc ?init_amount ?final_amount - amount)
        :duration ( = ?duration 5)
        :condition (and 
            (at start (robot_at ?r ?l))
            (at start (carrier_at ?k ?l))
            (at start (person_at ?p ?l))
            (at start (needs ?p ?cont))
            (at start (contains ?c ?cont))
            (at start (bearing ?k ?c))
            (at start (pop ?init_amount ?final_amount))
            (at start (is_empty ?r))

            (over all (crate_count ?k ?init_amount))
        )
        :effect (and 
            (at start (not (is_empty ?r)))
            (at end (not (needs ?p ?cont)))
            (at end (not_needs ?p ?cont))
            (at end (delivered_to ?p ?c))
            (at end (not (bearing ?k ?c)))
            (at end (crate_at ?c ?l))
            (at end (not (crate_count ?k ?init_amount)))
            (at end (crate_count ?k ?final_amount))
            (at end (is_empty ?r))
        )
    )
)
