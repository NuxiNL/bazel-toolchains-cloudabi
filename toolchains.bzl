load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_LLVM_BUILD_FILE = """
exports_files([
    "bin/clang-7",
    "bin/lld",
    "bin/llvm-ar",
])

filegroup(
    name = "clang_headers",
    srcs = glob(
        include = ["lib/clang/*/include/**"],
        exclude = [
            "lib/clang/*/include/float.h",
            "lib/clang/*/include/inttypes.h",
            "lib/clang/*/include/iso646.h",
            "lib/clang/*/include/limits.h",
            "lib/clang/*/include/stdalign.h",
            "lib/clang/*/include/stdarg.h",
            "lib/clang/*/include/stdatomic.h",
            "lib/clang/*/include/stdbool.h",
            "lib/clang/*/include/stddef.h",
            "lib/clang/*/include/stdint.h",
            "lib/clang/*/include/stdnoreturn.h",
            "lib/clang/*/include/tgmath.h",
        ],
    ),
    visibility = ["//visibility:public"],
)
"""

_PACKAGES_BUILD_FILE = """
filegroup(
    name = "include",
    srcs = glob(["usr/x86_64-unknown-cloudabi/include/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "lib",
    srcs = glob(["usr/x86_64-unknown-cloudabi/lib/**"]),
    visibility = ["//visibility:public"],
)
"""

def toolchains_cloudabi_dependencies():
    http_archive(
        name = "org_llvm_llvm_x86_64_apple_darwin",
        build_file_content = _LLVM_BUILD_FILE,
        sha256 = "b3ad93c3d69dfd528df9c5bb1a434367babb8f3baea47fbb99bf49f1b03c94ca",
        strip_prefix = "clang+llvm-7.0.0-x86_64-apple-darwin",
        urls = ["https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-apple-darwin.tar.xz"],
    )

    http_archive(
        name = "org_llvm_llvm_x86_64_unknown_freebsd",
        build_file_content = _LLVM_BUILD_FILE,
        sha256 = "95ceb933ccf76e3ddaa536f41ab82c442bbac07cdea6f9fbf6e3b13cc1711255",
        strip_prefix = "clang+llvm-7.0.0-amd64-unknown-freebsd11",
        urls = ["https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-amd64-unknown-freebsd11.tar.xz"],
    )

    http_archive(
        name = "org_llvm_compiler_rt_x86_64_unknown_cloudabi",
        build_file_content = _PACKAGES_BUILD_FILE,
        sha256 = "2e7e84384498dfae57f8bde8c3b988b2945b00f62e8fa8020553db3e1cfeb2ad",
        urls = ["https://nuxi.nl/distfiles/cloudabi-ports/archlinux/x86_64-unknown-cloudabi-compiler-rt-5.0.0-2-any.pkg.tar.xz"],
    )

    http_archive(
        name = "org_llvm_libcxx_x86_64_unknown_cloudabi",
        build_file_content = _PACKAGES_BUILD_FILE,
        sha256 = "28b7124ccbef636baa45dbc9bb1f1df2a2632df065ea26676ffb5b8f667c2a37",
        urls = ["https://nuxi.nl/distfiles/cloudabi-ports/archlinux/x86_64-unknown-cloudabi-libcxx-5.0.0-4-any.pkg.tar.xz"],
    )

    http_archive(
        name = "org_llvm_libcxxabi_x86_64_unknown_cloudabi",
        build_file_content = _PACKAGES_BUILD_FILE,
        sha256 = "f7e236e1da4333e5c19a7c4e890ed817b91302e667f60e0e4cca837195d6e341",
        urls = ["https://nuxi.nl/distfiles/cloudabi-ports/archlinux/x86_64-unknown-cloudabi-libcxxabi-5.0.0-3-any.pkg.tar.xz"],
    )

    http_archive(
        name = "org_llvm_libunwind_x86_64_unknown_cloudabi",
        build_file_content = _PACKAGES_BUILD_FILE,
        sha256 = "64e46aa8aae97e5fe278b4cc69098ec3ca6383088405e166afac7fa3d6434ee9",
        urls = ["https://nuxi.nl/distfiles/cloudabi-ports/archlinux/x86_64-unknown-cloudabi-libunwind-5.0.0-4-any.pkg.tar.xz"],
    )

    http_archive(
        name = "org_cloudabi_cloudlibc_x86_64_unknown_cloudabi",
        build_file_content = _PACKAGES_BUILD_FILE,
        sha256 = "a85d403d4bc06b5b74691e09c52bc37a1665d30ea48ba2c602976dbe73c4a531",
        urls = ["https://nuxi.nl/distfiles/cloudabi-ports/archlinux/x86_64-unknown-cloudabi-cloudlibc-0.103-1-any.pkg.tar.xz"],
    )
