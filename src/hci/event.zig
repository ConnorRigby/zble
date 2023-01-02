const std = @import("std");
pub const InquiryComplete       = @import("event/inquiry_complete.zig");
pub const DisconnectionComplete = @import("event/disconnection_complete.zig");
pub const CommandComplete       = @import("event/command_complete.zig");
pub const CommandStatus         = @import("event/command_status.zig");
pub const LEMeta                = @import("event/le_meta.zig");

pub const Code = enum(u8) {
  inquiry_complete       = InquiryComplete.Code,
  disconnection_complete = DisconnectionComplete.Code,
  command_complete       = CommandComplete.Code,
  command_status         = CommandStatus.Code,
  le_meta                = LEMeta.Code,
  _,
};

test {
  std.testing.refAllDecls(@This());
}
