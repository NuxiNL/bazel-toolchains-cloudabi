# Bazel toolchain definitions for CloudABI cross compilation

This repository contains definitions for the Bazel build system to cross
compile code for CloudABI.

These rules are still of very poor quality. They need to be extended to
be self-contained. These rules should download their own copy of LLVM,
as opposed to relying on the compiler provided by the host system.
