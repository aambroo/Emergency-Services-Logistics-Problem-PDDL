# Copyright 2019 Intelligent Robotics Lab
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, SetEnvironmentVariable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


def generate_launch_description():
    # Get the launch directory
    example_dir = get_package_share_directory('plansys2_emergency_transport')
    namespace = LaunchConfiguration('namespace')

    declare_namespace_cmd = DeclareLaunchArgument(
        'namespace',
        default_value='',
        description='Namespace')

    stdout_linebuf_envvar = SetEnvironmentVariable(
        'RCUTILS_CONSOLE_STDOUT_LINE_BUFFERED', '1')

    plansys2_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('plansys2_bringup'),
            'launch',
            'plansys2_bringup_launch_monolithic.py')),
        launch_arguments={
            'model_file': example_dir + '/pddl/emergency_transport.pddl',
            'namespace': namespace
        }.items())

    # Specify the actions
    move_cmd = Node(
        package='plansys2_emergency_transport',
        executable='move_action_node',
        name='move_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])

    go_back_to_deport_cmd = Node(
        package='plansys2_emergency_transport',
        executable='go_back_to_deport_action_node',
        name='go_back_to_deport_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])

    load_cmd = Node(
        package='plansys2_emergency_transport',
        executable='load_action_node',
        name='load_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])

    delivery_cmd = Node(
        package='plansys2_emergency_transport',
        executable='delivery_action_node',
        name='delivery_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    ld = LaunchDescription()

    # Set environment variables
    ld.add_action(stdout_linebuf_envvar)
    ld.add_action(declare_namespace_cmd)

    # Declare the launch options
    ld.add_action(plansys2_cmd)

    ld.add_action(move_cmd)
    ld.add_action(go_back_to_deport_cmd)
    ld.add_action(load_cmd)
    ld.add_action(delivery_cmd)

    return ld
