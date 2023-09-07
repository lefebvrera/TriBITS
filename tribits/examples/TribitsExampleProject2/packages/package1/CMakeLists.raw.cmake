cmake_minimum_required(VERSION 3.23.0 FATAL_ERROR)

if (COMMAND tribits_package)
  message("Configuring raw CMake package Package1")
else()
  message("Configuring raw CMake project Package1")
endif()

# Standard project-level stuff
project(Package1 LANGUAGES C CXX)
include(GNUInstallDirs)
find_package(Tpl1 CONFIG REQUIRED)
add_subdirectory(src)
if (Package1_ENABLE_TESTS)
  include(CTest)
  if (Package1_USE_TRIBITS_TEST_FUNCTIONS AND Package1_TRIBITS_DIR)
    set(Package1_ENABLE_TESTS ON)
    include("${Package1_TRIBITS_DIR}/core/test_support/TribitsAddTest.cmake")
    include("${Package1_TRIBITS_DIR}/core/test_support/TribitsAddAdvancedTest.cmake")
  endif()
  add_subdirectory(test)
endif()

# Generate the all_libs target(s)
add_library(Package1_all_libs INTERFACE)
set_target_properties(Package1_all_libs PROPERTIES
  EXPORT_NAME all_libs)
target_link_libraries(Package1_all_libs INTERFACE Package1_package1)
install(TARGETS Package1_all_libs
  EXPORT ${PROJECT_NAME}
  COMPONENT ${PROJECT_NAME}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} )
add_library(Package1::all_libs ALIAS Package1_all_libs)

if (COMMAND tribits_package)
  # Generate Package1Config.cmake file for the build tree (for internal
  # TriBITS-compliant package)
  set(packageBuildDirCMakePackagesDir
    "${${CMAKE_PROJECT_NAME}_BINARY_DIR}/cmake_packages/${PROJECT_NAME}")
  export(EXPORT ${PROJECT_NAME}
    NAMESPACE ${PROJECT_NAME}::
    FILE "${packageBuildDirCMakePackagesDir}/${PROJECT_NAME}ConfigTargets.cmake" )
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/raw/Package1Config.cmake.in"
    "${packageBuildDirCMakePackagesDir}/${PROJECT_NAME}/Package1Config.cmake"
    @ONLY )
endif()

# Generate and install the Package1Config.cmake file for the install tree
# (needed for both internal and external TriBITS package)
set(pkgConfigInstallDir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
install(EXPORT ${PROJECT_NAME}
  DESTINATION "${pkgConfigInstallDir}"
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}ConfigTargets.cmake )
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/raw/Package1Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/Package1Config.install.cmake"
  @ONLY )
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/Package1Config.install.cmake"
  RENAME "Package1Config.cmake"
  DESTINATION "${pkgConfigInstallDir}" )
