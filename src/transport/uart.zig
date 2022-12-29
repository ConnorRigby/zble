const std = @import("std");

pub const HCI = @import("../hci.zig");

pub const Reader = std.fs.File.Reader;

pub fn receive_packet(reader: Reader) !HCI.Packet {
  packet_type_blk: while(true) {
    const packet_type = try reader.readEnum(HCI.PacketType, .Little);
    switch(packet_type) {
      .event => return receive_event(reader),
      else => |unhandled_packet_type| {
        std.log.err("Unhandled packet {any}", .{unhandled_packet_type});
        break :packet_type_blk;
      }
    }
  }
  return std.fs.File.ReadError.InputOutput;
}

fn receive_event(reader: Reader) !HCI.Packet {
  var event_type = try reader.readEnum(HCI.Event.Code, .Little);
  switch(event_type) {
    .command_complete => return receive_command_complete(reader),
    else => |unhandled_event_type| {
      std.log.err("Unhandled event {any}", .{unhandled_event_type});
    }
  }
  return error.InvalidValue;
}

fn receive_command_complete(reader: Reader) !HCI.Packet {
  var length = try reader.readByte();
  var num_hci_command_packets = try reader.readByte();
  var command_opcode = try reader.readEnum(HCI.Command.OPC, .Big);
  var return_parameters = try receive_return_parameters(reader, command_opcode, length);
  var command_complete = .{
    .num_hci_command_packets = num_hci_command_packets,
    .command_opcode = command_opcode,
    .return_parameters = return_parameters
  };
  return .{.event = .{.command_complete = command_complete}};
}

fn receive_return_parameters(reader: Reader, command_opcode: HCI.Command.OPC, length: u8) !HCI.Event.CommandComplete.ReturnParameters {
  switch(command_opcode) {
    .read_local_name => return .{.read_local_name = .{
      .error_code = try reader.readEnum(HCI.Event.CommandComplete.ErrorCode, .Little)
    }},
    .read_local_version => {
      var error_code = try reader.readEnum(HCI.Event.CommandComplete.ErrorCode, .Little);
      var hci_version = try reader.readByte();
      var hci_revision = try reader.readInt(u16, .Little);
      var lmp_pal_version = try reader.readByte();
      var manufacturer_name = try reader.readInt(u16, .Little);
      var lmp_pal_subversion = try reader.readInt(u16, .Little);
      return .{.read_local_version = .{
        .error_code = error_code,
        .hci_version = hci_version,
        .hci_revision = hci_revision,
        .lmp_pal_version = lmp_pal_version,
        .manufacturer_name = manufacturer_name,
        .lmp_pal_subversion = lmp_pal_subversion,
      }};
    },
    else => |opcode| {
      std.log.warn("unhandled opcode={any}", .{opcode});
      var error_code = try reader.readEnum(HCI.Event.CommandComplete.ErrorCode, .Little);
      std.log.warn("error code={any}", .{error_code});
      try drain(reader, length-4);
      unreachable;
    }
  }
}

fn drain(reader: Reader, amount: u8) !void {
  var i:u8 = 0;
  while(i < amount):(i = i + 1) {
    var b = try reader.readByte();
    std.log.warn("unknown byte={x:0>2}", .{b});
  }
  return error.InvalidValue;
}