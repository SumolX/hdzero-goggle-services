# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/dosfstools/src"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/dosfstools/out"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/tmp"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/src/dosfstools-populate-stamp"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/src"
  "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/src/dosfstools-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/src/dosfstools-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Project Source/sandboxGitHub/hdzero-goggle-services/out/build/x64-Debug/_deps/dosfstools-subbuild/dosfstools-populate-prefix/src/dosfstools-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
