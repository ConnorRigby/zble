const std = @import("std");
const HCI = @import("../../hci.zig");

pub const LEMeta = @This();
pub const Code = 0x3E;

pub const ConnectionComplete = @import("le_meta/connection_complete.zig");

pub const SubeventCode = enum(u8) {
  connection_complete = ConnectionComplete.SubeventCode,
  _
};

pub const Subevent = union(SubeventCode) {
  connection_complete: ConnectionComplete,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .connection_complete => |connection_complete| writer.print("connection_complete: {any}", .{connection_complete}),
      else => |d| writer.print("{any}", .{d})
    };
  }
};

subevent: Subevent,
