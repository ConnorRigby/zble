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

pub const CommandData = union(Command.OPC) {
  set_event_mask:                         Command.ControllerAndBaseband.SetEventMask,
  read_local_version:                     Command.InformationalParameters.ReadLocalVersion,
  read_buffer_size_v1:                    Command.LEController.ReadBufferSizeV1,
  reset:                                  Command.ControllerAndBaseband.Reset,
  set_random_address:                     Command.LEController.SetRandomAddress,
  set_advertising_parameters:             Command.LEController.SetAdvertisingParameters,
  set_advertising_data:                   Command.LEController.SetAdvertisingData,
  set_advertising_enable:                 Command.LEController.SetAdvertisingEnable,
  set_scan_parameters:                    Command.LEController.SetScanParameters,
  set_scan_enable:                        Command.LEController.SetScanEnable,
  create_connection_cancel:               Command.LEController.CreateConnectionCancel,
  write_default_link_policy_settings:     Command.LinkPolicy.WriteDefaultLinkPolicySettings,
  write_local_name:                       Command.ControllerAndBaseband.WriteLocalName,
  read_local_name:                        Command.ControllerAndBaseband.ReadLocalName,
  write_page_timeout:                     Command.ControllerAndBaseband.WritePageTimeout,
  write_scan_enable:                      Command.ControllerAndBaseband.WriteScanEnable,
  write_class_of_device:                  Command.ControllerAndBaseband.WriteClassOfDevice,
  write_synchronous_flow_control_enable:  Command.ControllerAndBaseband.WriteSynchronousFlowControlEnable,
  write_inquiry_mode:                     Command.ControllerAndBaseband.WriteInquiryMode,
  write_extended_inquiry_response:        Command.ControllerAndBaseband.WriteExtendedInquiryResponse,
  write_simple_pairing_mode:              Command.ControllerAndBaseband.WriteSimplePairingMode,
  write_default_erroneous_data_reporting: Command.ControllerAndBaseband.WriteDefaultErroneousDataReporting,
  write_le_host_support:                  Command.ControllerAndBaseband.WriteLEHostSupport,
  write_secure_connections_host_support:  Command.ControllerAndBaseband.WriteSecureConnectionsHostSupport,

  pub fn encode(command: CommandData, allocator: std.mem.Allocator) ![]u8 {
    return switch(command) {
      inline else => |payload| payload.encode(allocator),
    };
  }
};

pub const EventData = union(Event.Code) {
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
  pub fn encode(_: @This(), _: std.mem.Allocator) ![]u8 {
    return error.NotImplemented;
  }
};

pub const NotImplementedPacketType = struct {
  pub const Error = error { NotImplemented };
  pub fn encode(_: @This(), _: std.mem.Allocator) ![]u8 {
    return Error.NotImplemented;
  }
};

pub const Packet = union(PacketType) {
  command: CommandData,
  acl:     NotImplementedPacketType,
  sync:    NotImplementedPacketType,
  event:   EventData,
  iso:     NotImplementedPacketType,
  pub fn format(value: Packet, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    switch(value) {
      .event => return writer.print("event: {any}", .{value.event}),
      else => |d| return writer.print("{any}", .{d})
    }
  }

  /// Encode a packet into a slice of u8
  pub fn encode(packet: Packet, allocator: std.mem.Allocator) ![]u8 {
    return switch(packet) {
      inline else => |data| data.encode(allocator)
    };
  }
};

test {std.testing.refAllDecls(@This());}