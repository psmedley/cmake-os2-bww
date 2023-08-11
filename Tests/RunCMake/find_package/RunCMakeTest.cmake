include(RunCMake)

run_cmake(CMP0074-WARN)
run_cmake(CMP0074-OLD)
run_cmake(ComponentRequiredAndOptional)
run_cmake(FromPATHEnv)
run_cmake_with_options(FromPATHEnvDebugPkg --debug-find-pkg=Resolved)
run_cmake(FromPrefixPath)
run_cmake(GlobalImportTarget)
run_cmake(MissingNormal)
run_cmake(MissingNormalForceRequired)
run_cmake(MissingNormalRequired)
run_cmake(MissingNormalVersion)
run_cmake(MissingNormalWarnNoModuleOld)
run_cmake(MissingNormalWarnNoModuleNew)
run_cmake(MissingModule)
run_cmake(MissingModuleRequired)
run_cmake(MissingConfig)
run_cmake(MissingConfigDebug)
run_cmake_with_options(MissingConfigDebugPkg --debug-find-pkg=NotHere)
run_cmake(MissingConfigOneName)
run_cmake(MissingConfigRequired)
run_cmake(MissingConfigVersion)
run_cmake(MixedModeOptions)
run_cmake_with_options(ModuleModeDebugPkg --debug-find-pkg=Foo,Zot)
run_cmake(PackageRoot)
run_cmake(PackageRootNestedConfig)
run_cmake(PackageRootNestedModule)
run_cmake(PolicyPush)
run_cmake(PolicyPop)
run_cmake(RequiredOptionValuesClash)
run_cmake(FindRootPathAndPrefixPathAreEqual)
run_cmake(SetFoundFALSE)
run_cmake(WrongVersion)
run_cmake(WrongVersionConfig)
run_cmake(CMP0084-OLD)
run_cmake(CMP0084-WARN)
run_cmake(CMP0084-NEW)
run_cmake(WrongVersionRange)
run_cmake(EmptyVersionRange)
run_cmake(VersionRangeWithEXACT)
run_cmake(VersionRange)
run_cmake(VersionRange2)
run_cmake(VersionRange3)
run_cmake(VersionRange4)
run_cmake(VersionRangeConfig)
run_cmake(VersionRangeConfig2)
run_cmake(VersionRangeConfig02)
run_cmake(VersionRangeConfigStd)
run_cmake(VersionRangeConfigStd2)
run_cmake_with_options(IgnoreInstallPrefix  "-DCMAKE_INSTALL_PREFIX=${RunCMake_SOURCE_DIR}/PackageRoot/foo/cmake_root")
run_cmake(IgnorePath)
run_cmake(IgnorePrefixPath)
run_cmake(REGISTRY_VIEW-no-view)
run_cmake(REGISTRY_VIEW-wrong-view)
run_cmake(REGISTRY_VIEW-propagated)

file(
    GLOB SearchPaths_TEST_CASE_LIST
    LIST_DIRECTORIES TRUE
    "${RunCMake_SOURCE_DIR}/SearchPaths/*"
  )
foreach(TestCasePrefix IN LISTS SearchPaths_TEST_CASE_LIST)
  if(IS_DIRECTORY "${TestCasePrefix}")
    cmake_path(GET TestCasePrefix FILENAME TestSuffix)
    run_cmake_with_options(
      SearchPaths_${TestSuffix}
        "-DSearchPaths_ROOT=${TestCasePrefix}"
        "--debug-find-pkg=SearchPaths"
      )
  endif()
endforeach()

if(UNIX
    AND NOT MSYS # FIXME: This works on CYGWIN but not on MSYS
    )
  run_cmake(SetFoundResolved)
endif()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  # Tests using the Windows registry
  find_program(REG NAMES "reg.exe" NO_CACHE)
  if (REG)
    ## check host architecture
    cmake_host_system_information(RESULT result QUERY WINDOWS_REGISTRY "HKCU" SUBKEYS VIEW 64 ERROR_VARIABLE status)
    if (status STREQUAL "")
      set(ARCH "64bit")
    else()
      set(ARCH "32bit")
    endif()

    # crete some entries in the registry
    cmake_path(CONVERT "${RunCMake_SOURCE_DIR}/registry_host${ARCH}.reg" TO_NATIVE_PATH_LIST registry_data)
    execute_process(COMMAND "${REG}" import "${registry_data}" OUTPUT_QUIET ERROR_QUIET)

    run_cmake_with_options(Registry-query -DARCH=${ARCH})

    # clean-up registry
    execute_process(COMMAND "${REG}" delete "HKCU\\SOFTWARE\\Classes\\CLSID\\CMake-Tests\\find_package" /f OUTPUT_QUIET ERROR_QUIET)
    if (ARCH STREQUAL "64bit")
      execute_process(COMMAND "${REG}" delete "HKCU\\SOFTWARE\\Classes\\WOW6432Node\\CLSID\\CMake-Tests\\find_package" /f OUTPUT_QUIET ERROR_QUIET)
    endif()
  endif()
endif()
