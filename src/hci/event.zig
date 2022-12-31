const std = @import("std");
pub const InquiryComplete       = @import("event/inquiry_complete.zig");
pub const DisconnectionComplete = @import("event/disconnection_complete.zig");
pub const CommandComplete       = @import("event/command_complete.zig");
pub const CommandStatus         = @import("event/command_status.zig");

pub const LEMeta = struct {
  pub const Code = 0x3E;
  pub const AdvertisingReport  = @import("event/le_meta/advertising_report.zig");
  pub const ConnectionComplete = @import("event/le_meta/connection_complete.zig");
};

pub const Code = enum(u8) {
  inquiry_complete       = InquiryComplete.Code,
  disconnection_complete = DisconnectionComplete.Code,
  command_complete       = CommandComplete.Code,
  command_status         = CommandStatus.Code,
  le_meta                = LEMeta.Code
};

test {
  std.testing.refAllDecls(@This());
}
