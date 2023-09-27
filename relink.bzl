load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain", "use_cpp_toolchain")

def _relink_impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    cos = ctx.attr.lib[OutputGroupInfo].compilation_outputs
    print("Are {} compilation_outputs a directory? {}".format(ctx.attr.lib.label, cos.to_list()[0].is_directory))
    linking_outputs = cc_common.link(
        name = ctx.label.name,
        actions = ctx.actions,
        cc_toolchain = cc_toolchain,
        feature_configuration = feature_configuration,
        compilation_outputs = cc_common.create_compilation_outputs(pic_objects = cos),
        output_type = "dynamic_library"
    )
    return [DefaultInfo(files = depset(direct = [linking_outputs.library_to_link.dynamic_library]))]

relink = rule(
    implementation = _relink_impl,
    attrs = {
        "lib": attr.label(),
        "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
    },
    fragments = ["cpp"],
)
