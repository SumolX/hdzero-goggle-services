# Example configuration file for compiling for an Atmel SAM D20 Xplained
# Pro evaluation kit, on a Unix-like system, with a GNU toolchain.

# Configuration for a native build on a generic Unix-like system.

# Build directory.
BUILD = build

# Extension for executable files.
E =

# Extension for object files.
O = .o

# Prefix for library file name.
LP = lib

# Extension for library file name.
L = .a

# Prefix for DLL file name.
DP = lib

# Extension for DLL file name.
D = .so

# Output file names can be overridden directly. By default, they are
# assembled using the prefix/extension macros defined above.
# BEARSSLLIB = libbearssl.a
# BEARSSLDLL = libbearssl.so
# BRSSL = brssl
# TESTCRYPTO = testcrypto
# TESTSPEED = testspeed
# TESTX509 = testx509

# File deletion tool.
RM = rm -f

# Directory creation tool.
MKDIR = mkdir -p

# C compiler and flags.
#CC = cc
CFLAGS = -W -Wall -Os -fPIC
CCOUT = -c -o

# Static library building tool.
#AR = ar
ARFLAGS = -rcs
AROUT =

# DLL building tool.
LDDLL = ${CC}
LDDLLFLAGS = -shared
LDDLLOUT = -o

# Static linker.
LD = ${CC}
LDFLAGS = 
LDOUT = -o 

# C# compiler; we assume usage of Mono.
MKT0COMP = mk$PmkT0.sh
RUNT0COMP = mono T0Comp.exe

# Set the values to 'no' to disable building of the corresponding element
# by default. Building can still be invoked with an explicit target call
# (e.g. 'make dll' to force build the DLL).
#STATICLIB = no
#DLL = no
#TOOLS = no
TESTS = no
