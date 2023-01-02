const std = @import("std");

const CommandComplete = @import("../command_complete.zig");
const ErrorCode = CommandComplete.ErrorCode;

/// The HCI_LE_Connection_Complete event indicates to both of the Hosts forming
/// the connection that a new connection has been created.
/// 
/// Upon the creation of the connection a Connection_Handle shall be assigned by
/// the Controller, and passed to the Host in this event. If the connection
/// creation fails this event shall be provided to the Host that had issued the
/// HCI_LE_Create_Connection command.
/// 
/// This event indicates to the Host which issued an HCI_LE_Create_Connection
/// command and received an HCI_Command_Status event if the connection creation
/// failed or was successful.
/// 
/// The Master_Clock_Accuracy parameter is only valid for a slave. On a master,
/// this parameter shall be set to 0x00.
/// 
/// Note: This event is not sent if the HCI_LE_Enhanced_Connection_Complete event
/// (see Section 7.7.65.10) is unmasked.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.65.1
pub const ConnectionComplete = @This();

pub const Code = 0x3E;
pub const SubeventCode = 0x01;

pub const Role = enum(u8) {
  Central = 0x0,
  Peripheral = 0x1,
  _,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .Central => writer.print("Central", .{}),
      .Peripheral => writer.print("Peripheral", .{}),
      else => |d| writer.print("{any}", .{d})
    };
  }
};

pub const PeerAddressType = enum(u8) {
  PublicDeviceAddress = 0x0,
  RandomDeviceAddress = 0x1,
  _,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .PublicDeviceAddress => writer.print("PublicDeviceAddress", .{}),
      .RandomDeviceAddress => writer.print("RandomDeviceAddress", .{}),
      else => |d| writer.print("{any}", .{d})
    };
  }
};

pub const PeerAddress = [6]u8;

pub const CentralClockAccuracy = enum(u8) {
  PPM_500 = 0x0,
  PPM_250 = 0x01,
  PPM_150 = 0x02,
  PPM_100 = 0x03,
  PPM_075 = 0x04,
  PPM_050 = 0x05,
  PPM_030 = 0x06,
  PPM_020 = 0x07,  
  _,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .PPM_500 => writer.print("ClockAccuracy(500ppm)", .{}),
      .PPM_250 => writer.print("ClockAccuracy(250ppm)", .{}),
      .PPM_150 => writer.print("ClockAccuracy(150ppm)", .{}),
      .PPM_100 => writer.print("ClockAccuracy(100ppm)", .{}),
      .PPM_075 => writer.print("ClockAccuracy(075ppm)", .{}),
      .PPM_050 => writer.print("ClockAccuracy(050ppm)", .{}),
      .PPM_030 => writer.print("ClockAccuracy(030ppm)", .{}),
      .PPM_020 => writer.print("ClockAccuracy(020ppm)", .{}),
      else => |d| writer.print("{any}", .{d})
    };
  }
};

status: ErrorCode,
handle: u12,
role: Role,
peer_address_type: PeerAddressType,
peer_address: PeerAddress,
connection_interval: u16,
peripheral_latency: u16,
supervision_timeout: u16,
central_clock_accuracy: CentralClockAccuracy
