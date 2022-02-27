cmake_minimum_required(VERSION 3.5)
project(plansys2_emergency_planning)


find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)

set(CMAKE_CXX_STANDARD 17)

set(dependencies
    rclcpp
    rclcpp_action
    plansys2_msgs
    plansys2_executor
)

add_executable(move_action_node src/move_action_node.cpp)
ament_target_dependencies(move_action_node ${dependencies})

add_executable(go_back_to_deport_action_node src/go_back_to_deport_action_node.cpp)
ament_target_dependencies(go_back_to_deport_action_node ${dependencies})

add_executable(load_action_node src/load_action_node.cpp)
ament_target_dependencies(load_action_node ${dependencies})

add_executable(delivery_action_node src/delivery_action_node.cpp)
ament_target_dependencies(delivery_action_node ${dependencies})

install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})

install(TARGETS
  move_action_node
  go_back_to_deport_action_node
  load_action_node
  delivery_action_node
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  find_package(ament_cmake_gtest REQUIRED)
endif()

ament_export_dependencies(${dependencies})

ament_package()