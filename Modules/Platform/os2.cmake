# set the platform tag
SET(OS2 1)

# also add the install directory of the running cmake to the search directories
# CMAKE_ROOT is CMAKE_INSTALL_PREFIX/share/cmake, so we need to go two levels up
get_filename_component(_CMAKE_INSTALL_DIR "${CMAKE_ROOT}" PATH)
get_filename_component(_CMAKE_INSTALL_DIR "${_CMAKE_INSTALL_DIR}" PATH)

# List common installation prefixes.  These will be used for all
# search types.
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
  # Standard
  /@unixroot/usr/local /@unixroot/usr

  # CMake install location
  "${_CMAKE_INSTALL_DIR}"
  )

list(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
  /@unixroot/usr/lib
  )

list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES
  /@unixroot/usr/include
  )
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES
  /@unixroot/usr/include
  )

SET(CMAKE_DL_LIBS "" )

# set flags for shared libraries
SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-Zdll")
SET(CMAKE_SHARED_LIBRARY_PREFIX "")
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
SET(CMAKE_SHARED_LIBRARY_C_FLAGS " ")
SET(CMAKE_SHARED_LIBRARY_CXX_FLAGS " ")
SET(CMAKE_SHARED_LINKER_FLAGS_INIT "-Zomf -Zdll")
# Shared libraries on OS/2 are named with their version number.
SET(CMAKE_SHARED_LIBRARY_NAME_WITH_VERSION 1)

# set flags for modules (almost as shared libraries)
SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS})
SET(CMAKE_SHARED_MODULE_PREFIX "")
SET(CMAKE_SHARED_MODULE_SUFFIX ".dll")
SET(CMAKE_MODULE_LINKER_FLAGS_INIT "-Zomf -Zdll")
# Modules have a different default prefix than shared libs.
SET(CMAKE_MODULE_EXISTS 1)

# set flags for import libraries
SET(CMAKE_IMPORT_LIBRARY_PREFIX "")
SET(CMAKE_IMPORT_LIBRARY_SUFFIX "_dll.a")

# set flags for static libraries
SET(CMAKE_STATIC_LIBRARY_PREFIX "")
SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

# set flags for executables
SET(CMAKE_EXECUTABLE_SUFFIX ".exe")
SET(CMAKE_EXE_LINKER_FLAGS_INIT "-Zomf")

# set compiler options
SET(CMAKE_C_COMPILE_OPTIONS_PIC "")
SET(CMAKE_CXX_COMPILE_OPTIONS_PIC "")
SET(CMAKE_C_COMPILE_OPTIONS_PIE "")
SET(CMAKE_CXX_COMPILE_OPTIONS_PIE "")
SET(CMAKE_C_OUTPUT_EXTENSION ".o")
SET(CMAKE_CXX_OUTPUT_EXTENSION ".o")
SET(CMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS 1)
SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_OBJECTS 1)
SET(CMAKE_C_USE_RESPONSE_FILE_FOR_INCLUDES 1)
SET(CMAKE_CXX_USE_RESPONSE_FILE_FOR_INCLUDES 1)

# set linker options
SET(CMAKE_C_LINK_FLAGS "-Zomf")
SET(CMAKE_CXX_LINK_FLAGS "-Zomf")

SET(CMAKE_FIND_LIBRARY_PREFIXES "" "lib")
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" "_dll.a" ".dll" ".a")


SET(CMAKE_C_CREATE_SHARED_MODULE
  "<CMAKE_C_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_MODULE_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_C_FLAGS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES>")
SET(CMAKE_CXX_CREATE_SHARED_MODULE
  "<CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_MODULE_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES>")

# Init the buildlevel settings, if not set in the main CMakeList.txt.
# To enable them in the main CMakeList.txt use the below snippet as a reference.
# If there is no VERSION or VERSION_PATCH set in CMakeList.txt, either remove
# this definition, or set it to your liking.
#
#  if(OS2)
#    SET(VERSION_BLDLevel ${VERSION} CACHE TYPE STRING)
#    SET(PATCH_BLDLevel ${VERSION_PATCH} CACHE TYPE STRING)
#    SET(VENDOR_BLDLevel "whoever you are" CACHE TYPE STRING)
#  endif(OS2)

if(NOT VENDOR_BLDLevel)
  SET(VENDOR_BLDLevel "community")
endif(NOT VENDOR_BLDLevel)

if(NOT VERSION_BLDLevel)
  SET(VERSION_BLDLevel "0")
endif(NOT VERSION_BLDLevel)

if(NOT PATCH_BLDLevel)
  SET(PATCH_BLDLevel "0")
endif(NOT PATCH_BLDLevel)

# create the timestamp and build maschine name
string(TIMESTAMP TSbldLevel "%d %b %Y %H:%M:%S")
exec_program(uname ARGS -n OUTPUT_VARIABLE unamebldLevel)
SET(bldLevelInfo "\#\#1\#\# ${TSbldLevel}\\ \\ \\ \\ \\ ${unamebldLevel}")

SET(CMAKE_C_CREATE_SHARED_LIBRARY
  "echo LIBRARY <TARGET_OS2DEF> INITINSTANCE TERMINSTANCE > <TARGET_BASE>.def && echo DESCRIPTION \\\"@\#${VENDOR_BLDLevel}:${VERSION_BLDLevel}\#@${bldLevelInfo}::::${PATCH_BLDLevel}::@@<TARGET_NAME>\\\" >> <TARGET_BASE>.def && echo DATA MULTIPLE NONSHARED >> <TARGET_BASE>.def && echo EXPORTS >> <TARGET_BASE>.def && emxexp <OBJECTS> >> <TARGET_BASE>.def && <CMAKE_C_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES> <TARGET_BASE>.def && emximp -o <TARGET_IMPLIB> <TARGET_BASE>.def")
SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
  "echo LIBRARY <TARGET_OS2DEF> INITINSTANCE TERMINSTANCE > <TARGET_BASE>.def && echo DESCRIPTION \\\"@\#${VENDOR_BLDLevel}:${VERSION_BLDLevel}\#@${bldLevelInfo}::::${PATCH_BLDLevel}::@@<TARGET_NAME>\\\" >> <TARGET_BASE>.def && echo DATA MULTIPLE NONSHARED >> <TARGET_BASE>.def && echo EXPORTS >> <TARGET_BASE>.def && emxexp <OBJECTS> >> <TARGET_BASE>.def && <CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES> <TARGET_BASE>.def && emximp -o <TARGET_IMPLIB> <TARGET_BASE>.def")

SET(CMAKE_C_LINK_EXECUTABLE
  "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <LINK_LIBRARIES>")
SET(CMAKE_CXX_LINK_EXECUTABLE
  "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <LINK_LIBRARIES>")


# Initialize C link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
  SET(CMAKE_${type}_LINK_STATIC_C_FLAGS "")
  SET(CMAKE_${type}_LINK_DYNAMIC_C_FLAGS "")
ENDFOREACH(type)

IF(CMAKE_COMPILER_IS_GNUCC)
  SET (CMAKE_C_FLAGS_DEBUG_INIT "-g")
  SET (CMAKE_C_FLAGS_MINSIZEREL_INIT "-Os -DNDEBUG")
  SET (CMAKE_C_FLAGS_RELEASE_INIT "-O3 -DNDEBUG")
  SET (CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")
  SET (CMAKE_C_CREATE_PREPROCESSED_SOURCE "<CMAKE_C_COMPILER> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
  SET (CMAKE_C_CREATE_ASSEMBLY_SOURCE "<CMAKE_C_COMPILER> <FLAGS> -S <SOURCE> -o <ASSEMBLY_SOURCE>")
  IF(NOT APPLE)
    SET (CMAKE_INCLUDE_SYSTEM_FLAG_C "-isystem ")
  ENDIF(NOT APPLE)
ENDIF(CMAKE_COMPILER_IS_GNUCC)

IF(CMAKE_COMPILER_IS_GNUCXX)
  SET (CMAKE_CXX_FLAGS_DEBUG_INIT "-g")
  SET (CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-Os -DNDEBUG")
  SET (CMAKE_CXX_FLAGS_RELEASE_INIT "-O3 -DNDEBUG")
  SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")
  SET (CMAKE_CXX_CREATE_PREPROCESSED_SOURCE "<CMAKE_CXX_COMPILER> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
  SET (CMAKE_CXX_CREATE_ASSEMBLY_SOURCE "<CMAKE_CXX_COMPILER> <FLAGS> -S <SOURCE> -o <ASSEMBLY_SOURCE>")
  IF(NOT APPLE)
    SET (CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-isystem ")
  ENDIF(NOT APPLE)
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

SET(CMAKE_SIZEOF_VOID_P 4)
