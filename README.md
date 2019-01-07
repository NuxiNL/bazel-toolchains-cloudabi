# Bazel C/C++ toolchain definitions for CloudABI cross compilation

This repository contains toolchain definitions for the
[Bazel build system](https://bazel.build/) to cross compile C/C++ code
for [CloudABI](https://cloudabi.org/). Instead of relying on a toolchain
that is provided by the host operating system, these rules
automatically download development tools (e.g. [Clang](https://clang.llvm.org/))
and cross compile core C/C++ libraries (e.g.,
[cloudlibc](https://github.com/NuxiNL/cloudlibc)) during build. This has
the following advantages:

- It allows you to develop CloudABI applications without making any
  system-level changes. There is no need to install anything on your
  system, apart from an officially released version of Bazel.
- The toolchain may be versioned as part of the project, making it
  easier to obtain reproducible build output.
- It makes it easier to test upcoming versions of individual components
  (e.g., Clang, libc++, cloudlibc).

## Using these rules

Add the following code to your `WORKSPACE` file to declare the
toolchain.

```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "org_cloudabi_bazel_toolchains_cloudabi",
    # NOT VALID!  Replace this with a Git commit SHA.
    commit = "...",
    remote = "https://github.com/NuxiNL/bazel-toolchains-cloudabi.git",
)

load("@org_cloudabi_bazel_toolchains_cloudabi//:toolchains.bzl", "toolchains_cloudabi_dependencies")

toolchains_cloudabi_dependencies()
```

And add the following lines to `.bazelrc` to use the toolchain as part
of builds. This file may be stored in the same directory as `WORKSPACE`.

```
build --cpu=x86_64-unknown-cloudabi
build --crosstool_top=@org_cloudabi_bazel_toolchains_cloudabi//:toolchain
```

Commands like `bazel build` and `bazel test` will now cross compile
targets for CloudABI on x86-64.
