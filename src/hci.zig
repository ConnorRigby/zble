// HCI packet structure
// Volume 4 of the Bluetooth Spec
const std = @import("std");

pub const Transport = struct {
  pub const Uart = @import("transport/uart.zig");
};

pub const Command = @import("hci/command.zig");
pub const ACL     = struct {};
pub const Sync    = struct {};
pub const Event   = @import("hci/event.zig");
pub const ISO     = struct {};

pub const PacketType = enum(u8) {
  command = 0x01,
  acl     = 0x02,
  sync    = 0x03,
  event   = 0x04,
  iso     = 0x05
};

pub const Packet = union(PacketType) {
  command: union(Command.OPC) {
    // TODO 
  },
  acl:     ACL,
  sync:    Sync,
  event:   union(Event.Code) {
    inquiry_complete:       Event.InquiryComplete,
    disconnection_complete: Event.DisconnectionComplete,
    command_complete:       Event.CommandComplete,
    command_status:         Event.CommandStatus,
    le_meta:                Event.LEMeta,
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
      switch(value) {
        .command_complete => return writer.print("command_complete: {any}", .{value.command_complete}),
        else => |d| return writer.print("{any}", .{d})
      }
    }
  },
  iso:     ISO,

  pub fn format(value: Packet, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    switch(value) {
      .event => return writer.print("event: {any}", .{value.event}),
      else => |d| return writer.print("{any}", .{d})
    }
  }
};