const std = @import("std");
pub const OGF: u6 = 0x2;

pub const WriteDefaultLinkPolicySettings = @import("link_policy/write_default_link_policy_settings.zig");

test {
  std.testing.refAllDecls(@This());
}