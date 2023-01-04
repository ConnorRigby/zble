const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const bison = b.addSystemCommand(&[_][]const u8 {"bison", "-b", "lib/dtc/", "-d", "lib/dtc/dtc-parser.y", "-o", "lib/dtc/dtc-parser.tab.c"});
    const flex = b.addSystemCommand(&[_][]const u8 {"flex", "-o", "lib/dtc/dtc-lexer.lex.c", "lib/dtc/dtc-lexer.l"});

    const libdtc_cflags = [_][]const u8 {
        "-std=c99",
        "-Wall", 
        "-Wpointer-arith", 
        "-Wcast-qual", 
        "-Wnested-externs", 
        "-Wsign-compare", 
        "-Wstrict-prototypes", 
        "-Wmissing-prototypes", 
        "-Wredundant-decls", 
        "-Wshadow"
    };
    const libdtc = b.addExecutable("dtc", null);
    libdtc.linkLibC();
    libdtc.linkSystemLibrary("yaml-0.1");
    libdtc.addIncludePath("lib/dtc/");
    libdtc.addIncludePath("lib/dtc/libfdt");
    libdtc.addIncludePath("support/dtc/");
    libdtc.addCSourceFile("lib/dtc/checks.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/data.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/flattree.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/fstree.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/livetree.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/srcpos.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/treesource.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/util.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/dtc.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/dtc-lexer.lex.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/dtc-parser.tab.c", &libdtc_cflags);
    libdtc.addCSourceFile("lib/dtc/yamltree.c", &libdtc_cflags);
    libdtc.setBuildMode(.ReleaseFast);
    libdtc.install();
    libdtc.step.dependOn(&bison.step);
    libdtc.step.dependOn(&flex.step);

    const lib = b.addStaticLibrary("zble", "src/zble.zig");
    lib.setBuildMode(mode);
    lib.install();

    const exe = b.addExecutable("zble-tester", "src/main.zig");
    exe.addPackagePath("serial", "lib/serial/src/serial.zig");
    exe.addPackagePath("zble", "src/zble.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);

    const dtc_cmd = libdtc.run();
    dtc_cmd.step.dependOn(b.getInstallStep());

    const dtc_step = b.step("dtc", "Run dtc");
    dtc_step.dependOn(&dtc_cmd.step);

    const main_tests = b.addTest("src/zble.zig");
    const coverage = b.option(bool, "coverage", "Generate test coverage") orelse false;
    main_tests.setBuildMode(mode);
    if (coverage) {
        // with kcov
        main_tests.setExecCmd(&[_]?[]const u8{
            "kcov",
            "--exclude-pattern=zig-*/",
            "--exclude-pattern=lib/",
            //"--path-strip-level=3", // any kcov flags can be specified here
            "kcov-output", // output dir for kcov
            null, // to get zig to use the --test-cmd-bin flag
        });
    }

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    //Build step to generate docs:
    const docs = b.addTest("src/zble.zig");
    if (coverage) {
        // with kcov
        docs.setExecCmd(&[_]?[]const u8{
            "kcov",
            "--exclude-pattern=zig-*/",
            "--exclude-pattern=lib/",
            //"--path-strip-level=3", // any kcov flags can be specified here
            "docs/coverage", // output dir for kcov
            null, // to get zig to use the --test-cmd-bin flag
        });
    }
    docs.setBuildMode(mode);
    docs.emit_docs = .emit;

    const docs_step = b.step("docs", "Generate docs");
    docs_step.dependOn(&docs.step);
}
