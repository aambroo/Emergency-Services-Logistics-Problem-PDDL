# PDDL Assignment <!-- omit-in-toc -->

#### Authors: <!-- omit-in-toc -->
- **Eliana Battisti** – eliana.battisti-1@studenti.unitn.it
- **Matteo Ambrosini** – matteo.ambrosini@studenti.unitn.it


# Problem Statement

This repository aims at illustrating how to address a resource allocation problem, contextualized in the real world as an emergency services logistics problem.
Will start off with an oversimplified version of the main problem (`Problem 1`), and will develop it on our way to `Problem 4`. Each problem, in turn, will contain additional features that make the whole environment, and the interaction of the agent with the environ- ment increasingly close to reality.
The frameworks used to carry out the first part of this project are those provided by the `planutils` suite, and [`PlanSys2`](https://github.com/IntelligentRoboticsLabs/ros2_planning_system).


# Problem Setting

The setting of the **main problem** is inspired by a real-world scenario, specifically an *emergency services logistics problem*.
The environment is composed of several locations. Each location can be initially populated by either *people* or *crates*. Each person might be in need of either medical supplies or feeding supplies, or both, or none. Accordingly, crates might contain *food* or *medicines*. Each person in need of supplies will be provided with one (or more) crates, according to their needs. Each person's needs are specified at the initial condition (`:init`) of each problem. A robotic agent takes care of delivering the correct crate to the correct person, accord- ing to the needs, which will need to be specified as the initial condition of each problem. There is one location we consider to be fixed for each problem, which is called `depot` or `base`. The depot location can be seen as a base for the robotic agent and — in some problem formulations — a warehouse for the crates.
The **objective** of the planning system is having all people served with the correct amount of crates, with the correct supply type, at the correct location. Such an ob- jective is carried out by the robotic agent which will be able to choose an action amongst those ones specified by the plan- ner in the domain file.