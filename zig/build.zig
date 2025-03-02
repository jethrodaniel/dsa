const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "dsa",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    {
        b.installArtifact(lib);
    }

    const docs = b.step("docs", "Install docs into zig-out/docs");
    {
        const install = b.addInstallDirectory(.{
            .source_dir = lib.getEmittedDocs(),
            .install_dir = .prefix,
            .install_subdir = "docs",
        });

        docs.dependOn(&install.step);
    }

    const test_step = b.step("test", "Run unit tests");
    {
        // Note: we pass a `name` to these `b.addTest` calls so that the
        // `zig build test --summary all` output shows which tests ran.
        //
        // We can't use the filename itself as the `name` because `zig build`
        // will reject it, e.g:
        //
        // ```
        // panic: invalid name: 'src/root.zig'. It looks like a file path, but it is supposed to be the library or application name.
        // ```
        //
        const Test = struct {
            name: []const u8,
            file: []const u8,
        };

        const tests = [_]Test{
            Test{
                .name = "root",
                .file = "src/root.zig",
            },
            Test{
                .name = "singly_linked_list",
                .file = "src/singly_linked_list.zig",
            },
            Test{
                .name = "stack",
                .file = "src/stack.zig",
            },
            Test{
                .name = "insertion sort",
                .file = "src/sorting/insertion_sort.zig",
            },
            Test{
                .name = "merge sort",
                .file = "src/sorting/merge_sort.zig",
            },
            Test{
                .name = "quick sort",
                .file = "src/sorting/quick_sort.zig",
            },
        };

        for (tests) |test_case| {
            const name = test_case.name;
            const file = test_case.file;

            const unit_test = b.addTest(.{
                .name = name,
                .root_source_file = b.path(file),
                .target = target,
                .optimize = optimize,
            });
            const run = b.addRunArtifact(unit_test);
            test_step.dependOn(&run.step);
        }
    }
}
