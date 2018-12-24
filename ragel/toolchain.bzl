# Copyright 2018 the rules_ragel authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

RAGEL_TOOLCHAIN = "@io_bazel_rules_ragel//ragel:toolchain_type"

def _ragel_toolchain(ctx):
    (inputs, _, input_manifests) = ctx.resolve_command(
        command = "ragel",
        tools = [ctx.attr.ragel],
    )
    return platform_common.ToolchainInfo(
        _ragel_internal = struct(
            executable = ctx.executable.ragel,
            inputs = depset(inputs),
            input_manifests = input_manifests,
        ),
    )

ragel_toolchain = rule(
    _ragel_toolchain,
    attrs = {
        "ragel": attr.label(
            executable = True,
            cfg = "host",
        ),
    },
)

def ragel_context(ctx):
    toolchain = ctx.toolchains[RAGEL_TOOLCHAIN]
    impl = toolchain._ragel_internal
    return struct(
        toolchain = toolchain,
        executable = impl.executable,
        inputs = impl.inputs,
        input_manifests = impl.input_manifests,
        env = {},
    )
