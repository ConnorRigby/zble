const std = @import("std");

pub const OGF: u6 = 0x4;

pub const ReadLocalVersion = @import("informational_parameters/read_local_version.zig");

test {
  std.testing.refAllDecls(@This());
}
