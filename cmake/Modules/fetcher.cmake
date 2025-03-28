include(FetchContent)

function(git_fetch package min_version fetch_version_or_branch source required scoped_build_params )
    # If provided a bare version number check for if it is already installed locally
    if (min_version MATCHES "^[0-9]+\.([0-9]+\.)*[0-9]+$")
      if (${required})
          find_package(${package} ${min_version} REQUIRED)
      else()
          find_package(${package} ${min_version} QUIET)
      endif()
    endif()

    if (${${package}_FOUND})
        message(STATUS "Found system ${package}")
    else()
        message(STATUS "Fetch ${package} ${fetch_version} from ${source}")
        FetchContent_Declare(${package} GIT_REPOSITORY ${source} GIT_TAG ${fetch_version})
        FetchContent_GetProperties(${package})
        if ( scoped_build_params )
          while( scoped_build_params )
            list(POP_FRONT scoped_build_params parname parval)
            message(STATUS "  Building ${package} with ${parname}=${parval}")
            set(${parname} "${parval}")
          endwhile()
        endif()
        if (NOT "${package}_POPULATED")
            FetchContent_Populate(${package})
            add_subdirectory("${${package}_SOURCE_DIR}" "${${package}_BINARY_DIR}")
        endif()
        set(${package}_FOUND ON PARENT_SCOPE)
        set("${package}_SOURCE_DIR" "${${package}_SOURCE_DIR}" PARENT_SCOPE)
        set("${package}_BINARY_DIR" "${${package}_BINARY_DIR}" PARENT_SCOPE)
    endif()
endfunction()
