(define (domain emergency_transport)
    (:requirements :strips :typing :adl :fluents :durative-actions)

    ;; Types ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (:types
        place - object
        locatable - object
        content - object
        capacity_number - object
        deport - place
        location - place
        person - locatable
        crate - locatable
        robot - locatable
        carrier - locatable
    );; end Types ;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Predicates ;;;;;;;;;;;;;;;;;;;;;;;;;
    (:predicates

        (robot_at_place ?r - robot ?p - place)
        (carrier_at_place ?carr - carrier ?p - place)
        (crate_at_place ?c - crate ?p - place)
        (person_at_place ?per - person ?p - place)

        (in ?c - crate ?carr - carrier)
        (has_content ?c - crate ?t - content)
        (has ?p - person ?t - content)
        (need ?p - person ?t - content)

        (is_crate_free ?c - crate)
        (is_robot_free ?r - robot)

        (capacity ?carr - carrier ?c - capacity_number)
        (capacity_predecessor ?c1 ?c2 - capacity_number)
        (is_max_capacity ?cap - capacity_number)

    );; end Predicates ;;;;;;;;;;;;;;;;;;;;
    ;; Functions ;;;;;;;;;;;;;;;;;;;;;;;;;
    (:functions

    );; end Functions ;;;;;;;;;;;;;;;;;;;;

    ;; Actions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;with this anction robot can move a carrier to a location
    ;from any place (charging station, deport)
    (:durative-action move
        :parameters (?r - robot ?carr - carrier ?start - place ?dest - location)
        :duration (= ?duration 5)
        :condition (and
            (at start (robot_at_place ?r ?start))
            (at start (carrier_at_place ?carr ?start))
            (at start (is_robot_free ?r))
        )
        :effect (and
            (at start (not (is_robot_free ?r)))
            (at start (not (robot_at_place ?r ?start)))
            (at end (robot_at_place ?r ?dest))
            (at start (not (carrier_at_place ?carr ?start)))
            (at end (carrier_at_place ?carr ?dest))
            (at end (is_robot_free ?r))
        )
    )

    ;with this anction robot (with carrier) can go to a deport
    ;from any place (charging station, location)
    (:durative-action go_back_to_deport
        :parameters (?r - robot ?carr - carrier ?p - place ?d - deport ?cap - capacity_number)
        :duration (= ?duration 5)
        :condition (and
            (at start (robot_at_place ?r ?p))
            (at start (carrier_at_place ?carr ?p))
            (at start (is_robot_free ?r))
            (over all (capacity ?carr ?cap))
            (over all (is_max_capacity ?cap)) ;check if carrier is empty --> has maximum capacity 
        )
        :effect (and
            (at start (not (is_robot_free ?r)))
            (at start (not (robot_at_place ?r ?p)))
            (at end (robot_at_place ?r ?d))
            (at start (not (carrier_at_place ?carr ?p)))
            (at end (carrier_at_place ?carr ?d))
            (at end (is_robot_free ?r))
        )
    )

    ;with this action robot load a crate into a carrier
    ;if all (the crate + the robot + the carrier) at the same place
    (:durative-action load
        :parameters (?r - robot ?c - crate ?carr - carrier ?p - place ?cap1 ?cap2 - capacity_number)
        :duration (= ?duration 2)
        :condition (and
            (over all (robot_at_place ?r ?p))
            (over all (carrier_at_place ?carr ?p))
            (at start (crate_at_place ?c ?p))
            (at start (is_crate_free ?c))
            (at start (is_robot_free ?r))
            (over all (capacity_predecessor ?cap1 ?cap2))
            (over all (capacity ?carr ?cap2))
        )
        :effect (and
            (at start (not (is_crate_free ?c)))
            (at start (not (is_robot_free ?r)))
            (at start (not (crate_at_place ?c ?p)))
            (at end (in ?c ?carr)) ;crate loaded into the carrier
            (at end (not (capacity ?carr ?cap2)))
            (at end (capacity ?carr ?cap1))
            (at end (is_crate_free ?c))
            (at end (is_robot_free ?r))
        )
    )

    ;with this action robot deliver a crate from the carrier to a person
    ;if all (the carrier + the robot + the person) at the same place
    ;and the crate is inside the carrier
    (:durative-action delivery
        :parameters (?r - robot ?carr - carrier ?c - crate ?t - content ?p - person ?l - location ?cap1 ?cap2 - capacity_number)
        :duration (= ?duration 2)
        :condition (and
            (over all (robot_at_place ?r ?l))
            (over all (carrier_at_place ?carr ?l))
            (over all (person_at_place ?p ?l))
            (at start (in ?c ?carr))
            (at start (has_content ?c ?t))
            (at start (need ?p ?t))
            (at start (is_crate_free ?c))
            (at start (is_robot_free ?r))
            (over all (capacity_predecessor ?cap1 ?cap2))
            (over all (capacity ?carr ?cap1))
        )
        :effect (and
            (at start (not (is_robot_free ?r)))
            (at start (not (in ?c ?carr)))
            (at start (not (is_crate_free ?c)))
            ;at end we do not free the crate so another agent can not load a delivaried crate
            (at end (crate_at_place ?c ?l))
            (at end (not (need ?p ?t)))
            (at end (has ?p ?t))
            (at end (is_robot_free ?r))
            (at end (capacity ?carr ?cap2))
            (at end (not (capacity ?carr ?cap1)))
        )
    )

);; end Domain ;;;;;;;;;;;;;;;;;;;;;;;;