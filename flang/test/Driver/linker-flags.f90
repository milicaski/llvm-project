! Verify that the Fortran runtime libraries are present in the linker
! invocation. These libraries are added on top of other standard runtime
! libraries that the Clang driver will include.

!-------------
! RUN COMMANDS
!-------------
! RUN: %flang -### -flang-experimental-exec -target ppc64le-linux-gnu %S/Inputs/hello.f90 2>&1 | FileCheck %s --check-prefixes=CHECK,GNU
! RUN: %flang -### -flang-experimental-exec -target aarch64-apple-darwin %S/Inputs/hello.f90 2>&1 | FileCheck %s --check-prefixes=CHECK,DARWIN
! RUN: %flang -### -flang-experimental-exec -target x86_64-windows-gnu %S/Inputs/hello.f90 2>&1 | FileCheck %s --check-prefixes=CHECK,MINGW

! NOTE: Clang's driver library, clangDriver, usually adds 'libcmt' and
!       'oldnames' on Windows, but they are not needed when compiling
!       Fortran code and they might bring in additional dependencies.
!       Make sure they're not added.
! RUN: %flang -### -flang-experimental-exec -target aarch64-windows-msvc %S/Inputs/hello.f90 2>&1 | FileCheck %s --check-prefixes=CHECK,MSVC --implicit-check-not libcmt --implicit-check-not oldnames

!----------------
! EXPECTED OUTPUT
!----------------
! Compiler invocation to generate the object file
! CHECK-LABEL: {{.*}} "-emit-obj"
! CHECK-SAME:  "-o" "[[object_file:.*\.o]]" {{.*}}Inputs/hello.f90

! Linker invocation to generate the executable
! GNU-LABEL:  "{{.*}}ld" 
! GNU-SAME: "[[object_file]]"
! GNU-SAME: -lFortran_main
! GNU-SAME: -lFortranRuntime
! GNU-SAME: -lFortranDecimal
! GNU-SAME: -lm

! DARWIN-LABEL:  "{{.*}}ld" 
! DARWIN-SAME: "[[object_file]]"
! DARWIN-SAME: -lFortran_main
! DARWIN-SAME: -lFortranRuntime
! DARWIN-SAME: -lFortranDecimal

! MINGW-LABEL:  "{{.*}}ld" 
! MINGW-SAME: "[[object_file]]"
! MINGW-SAME: -lFortran_main
! MINGW-SAME: -lFortranRuntime
! MINGW-SAME: -lFortranDecimal

! NOTE: This check should also match if the default linker is lld-link.exe
! MSVC-LABEL: link.exe
! MSVC-SAME: Fortran_main.lib
! MSVC-SAME: FortranRuntime.lib
! MSVC-SAME: FortranDecimal.lib
! MSVC-SAME: /subsystem:console
! MSVC-SAME: "[[object_file]]"
