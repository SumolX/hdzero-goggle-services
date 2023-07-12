# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/dropbear/src"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/dropbear/out"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/tmp"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/src/dropbear-populate-stamp"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/src"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/src/dropbear-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/src/dropbear-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dropbear-subbuild/dropbear-populate-prefix/src/dropbear-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
