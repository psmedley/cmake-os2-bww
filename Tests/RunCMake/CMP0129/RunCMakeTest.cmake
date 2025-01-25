set(RunCMake_TEST_NO_CMP0129 ON)
include(RunCMake)

run_cmake(C-WARN)
run_cmake(C-OLD)
run_cmake(C-NEW)
run_cmake(CXX-WARN)
run_cmake(CXX-OLD)
run_cmake(CXX-NEW)
if(CMake_TEST_Fortran)
  run_cmake(Fortran-WARN)
  run_cmake(Fortran-OLD)
  run_cmake(Fortran-NEW)
endif()
