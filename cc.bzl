def cc_binary_cloudabi(deps = [], *args, **kwargs):
    native.cc_binary(
        deps = deps + ["@org_cloudabi_bazel_toolchains_cloudabi//:cxx_runtime"],
        *args,
        **kwargs
    )

def cc_test_cloudabi(deps = [], *args, **kwargs):
    native.cc_test(
        deps = deps + ["@org_cloudabi_bazel_toolchains_cloudabi//:cxx_runtime"],
        *args,
        **kwargs
    )
