const std = @import("std");
// const serial = @import("lib/serial/build.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zble", "src/main.zig");
    lib.addPackagePath("serial", "lib/serial/src/serial.zig");
    lib.setBuildMode(mode);
    lib.install();

    const exe = b.addExecutable("tester", "src/main.zig");
    exe.addPackagePath("serial", "lib/serial/src/serial.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const main_tests = b.addTest("src/main.zig");
    main_tests.addPackagePath("serial", "lib/serial/src/serial.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    //Build step to generate docs:
    const docs = b.addTest("src/hci.zig");
    docs.setBuildMode(mode);
    docs.emit_docs = .emit;
    const docs_step = b.step("docs", "Generate docs");
    docs_step.dependOn(&docs.step);
}
