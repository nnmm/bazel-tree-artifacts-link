def _codegen_impl(ctx):
    out = ctx.actions.declare_directory("src")
    ctx.actions.run(
        outputs = [out],
        tools = [ctx.executable._generator],
        executable = ctx.executable._generator,
        arguments = [out.path]
    )
    return DefaultInfo(files = depset(direct = [out]))

codegen = rule(
    implementation = _codegen_impl,
    attrs = {
        "_generator": attr.label(
            default = "//:generator",
            executable = True,
            cfg = "exec"
        )
    }
)
