(define (problem problem_2)
    (:domain emergency_logistics_services_2)
    (:objects
        ;robot
        robot-1 - robot

        ;carrier
        carrier-1 - carrier

        ;content
        food medicine - content

        ;crates
        crate-1 crate-2 crate-3 crate-4 - crate
        crate-5 crate-6 crate-7 crate-8 - crate
        crate-9 crate-10 crate-11 - crate

        ;persons
        person-1 person-2 person-3 person-4 - person
        person-5 person-6 person-7 - person

        ;locations
        location-1 location-2 - location
        location-3 - location

        ;deport
        deport-0 - deport

        ;charging station
        charging-station-0 - charging-station
    )

    (:init
        (= (total-cost) 0)

        (= (battery-capacity) 5)
        (= (battery-amount robot-1) 5)

        (= (carrier-capacity) 4)
        (= (carrier-capacity-amount carrier-1) 4)

        ;define each crate initial position
        (at crate-1 deport-0)
        (at crate-2 deport-0)
        (at crate-3 deport-0)
        (at crate-4 deport-0)
        (at crate-5 deport-0)
        (at crate-6 deport-0)
        (at crate-7 deport-0)
        (at crate-8 deport-0)
        (at crate-9 deport-0)
        (at crate-10 deport-0)
        (at crate-11 deport-0)

        ;define each crate as free to deliver
        (is-free crate-1)
        (is-free crate-2)
        (is-free crate-3)
        (is-free crate-4)
        (is-free crate-5)
        (is-free crate-6)
        (is-free crate-7)
        (is-free crate-8)
        (is-free crate-9)
        (is-free crate-10)
        (is-free crate-11)

        ;define each robot initial position
        (at robot-1 deport-0)

        ;define each carrier initial position
        (at carrier-1 deport-0)

        ;define each crate content
        (has-content crate-1 food)
        (has-content crate-2 food)
        (has-content crate-3 food)
        (has-content crate-4 food)
        (has-content crate-5 food)
        (has-content crate-6 medicine)
        (has-content crate-7 medicine)
        (has-content crate-8 medicine)
        (has-content crate-9 medicine)
        (has-content crate-10 medicine)
        (has-content crate-11 medicine)

        ;define each person initial position
        (at person-1 location-1)
        (at person-2 location-1)
        (at person-3 location-2)
        (at person-4 location-2)
        (at person-5 location-3)
        (at person-6 location-3)
        (at person-7 location-3)

        ;define persons initial content situation
        (has person-1 food)
        (has person-1 medicine)
        (has person-2 medicine)
        (has person-3 food)
        (has person-6 food)
    )

    (:goal
        (and
            (has person-1 food)
            (has person-1 medicine)
            (has person-2 food)
            (has person-2 medicine)
            (has person-3 food)
            (has person-3 medicine)
            (has person-4 food)
            (has person-4 medicine)
            (has person-5 food)
            (has person-5 medicine)
            (has person-6 food)
            (has person-6 medicine)
            (has person-7 food)
            (has person-7 medicine)

            (at robot-1 deport-0)
        )
    )

    (:metric minimize
        (total-cost)
    )
)