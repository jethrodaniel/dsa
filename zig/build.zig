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

    const test_step = b.step("test", "Run unit tests");
    {
        const names = [_][]const u8{
            "root",
            "singly_linked_list",
        };
        for (names) |name| {
            const file = b.fmt("src/{s}.zig", .{name});

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
