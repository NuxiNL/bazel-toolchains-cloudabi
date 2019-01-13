def cc_binary_cloudabi(name, deps = [], *args, **kwargs):
    # Split up the binary into a separate library and a binary. This is
    # done to ensure we don't drag in all the header files from
    # cxx_runtime for all code in the binary.
    native.cc_library(
        name = name + "_library",
        deps = deps,
        *args,
        **kwargs
    )

    native.cc_binary(
        name = name,
        deps = [
            name + "_library",
            "@org_cloudabi_bazel_toolchains_cloudabi//:cxx_runtime",
        ],
        *args,
        **kwargs
    )

def cc_test_cloudabi(name, *args, **kwargs):
    # Binaries need to be launched through cloudabi-run. First compile
    # an executable separately.
    cc_binary_cloudabi(
        name = name + "_binary",
        *args,
        **kwargs
    )

    _run_test(
        name = name,
        executable = name + "_binary",
    )

def _run_test_impl(ctx):
    ctx.actions.write(
        output = ctx.outputs.executable,
        content = "PATH_CLOUDABI_REEXEC=%s %s %s" % (
            ctx.files._cloudabi_reexec[0].short_path,
            ctx.files._run_test[0].short_path,
            ctx.files.executable[0].short_path,
        ),
    )
    runfiles = ctx.runfiles(files = ctx.files.executable +
                                    ctx.files._cloudabi_reexec +
                                    ctx.files._run_test)
    return [DefaultInfo(runfiles = runfiles)]

_run_test = rule(
    attrs = {
        "_cloudabi_reexec": attr.label(
            executable = True,
            cfg = "target",
            default = "@org_cloudabi_cloudabi_utils//src/cloudabi-reexec",
        ),
        "_run_test": attr.label(
            executable = True,
            cfg = "host",
            default = "@org_cloudabi_bazel_toolchains_cloudabi//:run_test",
        ),
        "executable": attr.label(
            executable = True,
            cfg = "target",
            allow_single_file = True,
        ),
    },
    test = True,
    implementation = _run_test_impl,
)
