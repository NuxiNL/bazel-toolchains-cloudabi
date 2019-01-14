// Copyright (c) 2019 Nuxi, https://nuxi.nl/
//
// SPDX-License-Identifier: BSD-2-Clause

// run-test - run CloudABI executables as Bazel tests
//
// This utility spawns CloudABI executables that are intended to act as
// unit tests. These unit tests will only have access to a temporary
// directory and log output.

#include <argdata.h>
#include <errno.h>
#include <fcntl.h>
#include <program.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef O_EXEC
#define O_EXEC O_RDONLY
#endif

int main(int argc, char **argv) {
  // Test executable.
  int execfd = open(argv[1], O_EXEC);
  if (execfd == -1) {
    perror("Failed to open executable");
    return 1;
  }

  // Location where the test may store temporary files.
  int tmpdirfd = open(getenv("TEST_TMPDIR"), O_RDONLY);
  if (execfd == -1) {
    perror("Failed to open temporary directory");
    return 1;
  }

  // Run test executable with access to the temporary directory.
  const argdata_t *keys[2] = {
      argdata_create_str_c("tmpdir"),
      argdata_create_str_c("logfile"),
  };
  const argdata_t *values[2] = {
      argdata_create_fd(tmpdirfd),
      argdata_create_fd(STDOUT_FILENO),
  };
  errno = program_exec(execfd, argdata_create_map(keys, values, 2));
  perror("Failed to run test executable");
  return 1;
}
