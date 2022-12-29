const std = @import("std");
pub const InquiryComplete       = @import("event/inquiry_complete.zig");
pub const DisconnectionComplete = @import("event/disconnection_complete.zig");
pub const CommandComplete       = @import("event/command_complete.zig");
pub const CommandStatus         = @import("event/command_status.zig");

// should be an enum probably
pub const LEMeta = struct {
  pub const AdvertisingReport  = @import("event/le_meta/advertising_report.zig");
  pub const ConnectionComplete = @import("event/le_meta/connection_complete.zig");
};

pub const Code = enum(u8) {
  inquiry_complete       = 0x1,
  disconnection_complete = 0x5,
  command_complete       = 0xE,
  command_status         = 0xF,
  le_meta                = 0x3E
};

test {
  std.testing.refAllDecls(@This());
}
