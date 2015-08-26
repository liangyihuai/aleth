function(eth_apply TARGET REQUIRED )
	eth_use(${TARGET} ${REQUIRED} EthCore)
	if (DEFINED ethereum_SOURCE_DIR)
		set(SOL_DIR "${ethereum_SOURCE_DIR}/solidity")
		set(ETH_SOLIDITY_LIBRARY solidity)
	else()
		set(SOL_DIR "${CMAKE_CURRENT_LIST_DIR}/../solidity" CACHE PATH "The path to the solidity directory")
		set(SOL_BUILD_DIR_NAME  "build"                                             CACHE STRING "The name of the build directory in solidity repo")
		set(SOL_BUILD_DIR "${SOL_DIR}/${SOL_BUILD_DIR_NAME}")
		set(CMAKE_LIBRARY_PATH ${SOL_BUILD_DIR};${CMAKE_LIBRARY_PATH})
		find_library(ETH_SOLIDITY_LIBRARY NAMES solidity PATH_SUFFIXES "libsolidity" "solidity" "libsolidity/Release" )
		if (NOT ETH_SOLIDITY_LIBRARY)
			# NOT OPTIONAL, is a workaround for CMP0051
			if (NOT ("${REQUIRED}" STREQUAL "OPTIONAL"))
				message(FATAL_ERROR "Solidity library not found")
			endif()
			return()
		endif()
	endif()
	add_definitions(-DETH_SOLIDITY)
	message("Using Solidity library: ${ETH_SOLIDITY_LIBRARY}")
	include_directories(${SOL_DIR})
	target_link_libraries(${TARGET} ${ETH_SOLIDITY_LIBRARY})
endfunction()
