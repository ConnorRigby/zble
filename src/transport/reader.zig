const std = @import("std");
const log = std.log.scoped(.reader);

const Reader = std.fs.File.Reader;
const HCI   = @import("../hci.zig");
const Event = HCI.Event;
const ACL   = HCI.ACL;

const ReturnParameters   = Event.CommandComplete.ReturnParameters;
const ErrorCode          = Event.CommandComplete.ErrorCode;

const LEMeta             = Event.LEMeta;
const ConnectionComplete = LEMeta.ConnectionComplete;

const PacketType         = HCI.PacketType;
const Packet             = HCI.Packet;
const Opcode             = HCI.Command.OPC;

pub const Error = error {
  NotImplemented, // stub implementation
  UnhandledData   // unhandled error
};

/// receives a single HCI packet
pub fn receive(reader: Reader) !Packet {
  while(true) {
    const packet_type = try reader.readEnum(PacketType, .Little);
    log.err("starting receive", .{});
    return switch(packet_type) {
      .command => receive_command(reader),
      .acl     => receive_acl(reader),
      .sync    => receive_sync(reader),
      .event   => receive_event(reader),
      .iso     => receive_iso(reader)
    };
  }
  unreachable;
}

fn receive_command(reader: Reader) !Packet {
  _ = reader;
  // TODO: implement receiving Command packets
  return Error.NotImplemented;
}

fn receive_acl(reader: Reader) !Packet {
  std.log.err("receive acl", .{});
  const header = try reader.readStruct(HCI.ACL.Header);
  std.log.err("header={any}", .{header});

  var payload = std.mem.zeroes([27]u8);
  for(payload) |_,i| {
    if(i == header.length) break;
    if(i > header.length) @panic("unimplemented pdu length");
    std.log.err("i={d}", .{i});
    payload[i] = try reader.readByte();
    std.log.err("[{d}]{d}", .{i, payload[i]});
  }
  var pdu = .{.header = header, .data = payload};
  std.log.err("pdu={any}", .{pdu});
  return .{.acl = pdu};

  // const handle_and_flags = try reader.readInt(u16, .Little);
  // const handle = @truncate(u12, handle_and_flags, .Little);

  // const pb = (handle_and_flags >> 14) & 1;
  // const bc = (handle_and_flags >> 15) & 1;
  // const length = try reader.readInt(u16, .Little);
  // var data = std.mem.zeroes([27]u8);
  // for(data) |_,i| {
  //   data[i] = try reader.readByte();
  // }

  // return .{.handle = handle, .flags = .{.pb = pb, .bc = bc}, .length = length, .data = data};
}

fn receive_sync(reader: Reader) !Packet {
  _ = reader;
  // TODO: implement receiving sync packets
  return Error.NotImplemented;
}

fn receive_event(reader: Reader) !Packet {
  const event_type = try reader.readEnum(Event.Code, .Little);
  return switch(event_type) {
    .inquiry_complete       => receive_inquire_complete(reader),
    .disconnection_complete => receive_disconnection_complete(reader),
    .command_complete       => receive_command_complete(reader),
    .command_status         => receive_command_status(reader),
    .le_meta                => receive_le_meta(reader),
    else => |value| {
      std.log.err("unknown event type: {any}", .{value});
      unreachable;
    }
  };
}

fn receive_iso(reader: Reader) !Packet {
  _ = reader;
  // TODO: implement receiving ISO packets
  return Error.NotImplemented;
}

fn receive_inquire_complete(reader: Reader) !Packet {
    _ = reader;
  // TODO: implement receiving inquire_complete packets
  return Error.NotImplemented;
}

fn receive_disconnection_complete(reader: Reader) !Packet {
    _ = reader;
  // TODO: implement receiving disconnection_complete packets
  return Error.NotImplemented;
}

fn receive_command_complete(reader: Reader) !Packet {
  const length                  = try reader.readByte();
  const num_hci_command_packets = try reader.readByte();
  const command_opcode          = try reader.readEnum(Opcode, .Big);
  const return_parameters       = try receive_return_parameters(reader, command_opcode, length);
  const command_complete        = .{
    .num_hci_command_packets = num_hci_command_packets,
    .command_opcode          = command_opcode,
    .return_parameters       = return_parameters
  };
  return .{.event = .{.command_complete = command_complete}};
}

fn receive_command_status(reader: Reader) !Packet {
    _ = reader;
  // TODO: implement receiving command_status packets
  return Error.NotImplemented;
}

fn receive_le_meta(reader: Reader) !Packet {
  const length = try reader.readByte();
  const subevent = try reader.readEnum(LEMeta.SubeventCode, .Little);
  return switch(subevent) {
    .connection_complete => receive_le_meta_connection_complete(reader),
    else => |value| {
      std.log.err("unknown le_meat events {x}", .{value});
      try drain(reader, length);
      unreachable;
    }
  };
}

fn receive_le_meta_connection_complete(reader: Reader) !Packet {
  const error_code = try reader.readEnum(ErrorCode, .Little);
  const handle     = @truncate(u12, try reader.readInt(u16, .Little));
  const role       = try reader.readEnum(ConnectionComplete.Role, .Little);
  const peer_address_type = try reader.readEnum(ConnectionComplete.PeerAddressType, .Little);
  var peer_address = std.mem.zeroes([6]u8);
  var i: u8 = 0;
  while(i < 6):(i = i + 1) {peer_address[i] = try reader.readByte();}
  const connection_interval = try reader.readInt(u16, .Little);
  const peripheral_latency = try reader.readInt(u16, .Little);
  const supervision_timeout = try reader.readInt(u16, .Little);
  const central_clock_accuracy = try reader.readEnum(ConnectionComplete.CentralClockAccuracy, .Little);
  return .{.event = .{.le_meta = .{
    .subevent = .{.connection_complete = .{
      .status                 = error_code,
      .handle                 = handle,
      .role                   = role,
      .peer_address_type      = peer_address_type,
      .peer_address           = peer_address,
      .connection_interval    = connection_interval,
      .peripheral_latency     = peripheral_latency,
      .supervision_timeout    = supervision_timeout,
      .central_clock_accuracy = central_clock_accuracy,
    }}
  }}};
}

fn receive_return_parameters(reader: Reader, command_opcode: Opcode, length: u8) !ReturnParameters {
  return switch(command_opcode) {
    .set_event_mask                         => receive_return_parameters_set_event_mask(reader),
    .read_local_version                     => receive_return_parameters_read_local_version(reader),
    .read_buffer_size_v1                    => receive_return_parameters_read_buffer_size_v1(reader),
    .reset                                  => receive_return_parameters_reset(reader),
    .le_set_random_address                  => receive_return_parameters_le_set_random_address(reader),
    .le_set_advertising_parameters          => receive_return_parameters_le_set_advertising_parameters(reader),
    .le_set_advertising_data                => receive_return_parameters_le_set_advertising_data(reader),
    .le_set_advertising_enable              => receive_return_parameters_le_set_advertising_enable(reader),
    .le_set_scan_parameters                 => receive_return_parameters_le_set_scan_parameters(reader),
    .le_set_scan_enable                     => receive_return_parameters_le_set_scan_enable(reader),
    // .le_create_connection                   => receive_return_parameters_create_connection(reader),
    .le_create_connection_cancel            => receive_return_parameters_le_create_connection_cancel(reader),
    .write_default_link_policy_settings     => receive_return_parameters_write_default_link_policy_settings(reader),
    .write_local_name                       => receive_return_parameters_write_local_name(reader),
    .read_local_name                        => receive_return_parameters_read_local_name(reader),
    .write_page_timeout                     => receive_return_parameters_write_page_timeout(reader),
    .write_scan_enable                      => receive_return_parameters_write_scan_enable(reader),
    .write_class_of_device                  => receive_return_parameters_write_class_of_device(reader),
    .write_synchronous_flow_control_enable  => receive_return_parameters_write_synchronous_flow_control_enable(reader),
    .write_inquiry_mode                     => receive_return_parameters_write_inquiry_mode(reader),
    .write_extended_inquiry_response        => receive_return_parameters_write_extended_inquiry_response(reader),
    .write_simple_pairing_mode              => receive_return_parameters_write_simple_pairing_mode(reader),
    .write_default_erroneous_data_reporting => receive_return_parameters_write_default_erroneous_data_reporting(reader),
    .write_le_host_support                  => receive_return_parameters_write_le_host_support(reader),
    .write_secure_connections_host_support  => receive_return_parameters_write_secure_connections_host_support(reader),
    else => |value| {
      std.log.err("unknown return params {x}", .{value});
      try drain(reader, length);
      unreachable;
    }
  };
}

fn receive_return_parameters_set_event_mask(reader: Reader) !ReturnParameters {
  const error_code         = try reader.readEnum(ErrorCode, .Little);
  return .{.set_event_mask = .{.error_code = error_code}};
}

fn receive_return_parameters_read_local_version(reader: Reader) !ReturnParameters {
  const error_code             = try reader.readEnum(ErrorCode, .Little);
  const hci_version            = try reader.readByte();
  const hci_revision           = try reader.readInt(u16, .Little);
  const lmp_pal_version        = try reader.readByte();
  const manufacturer_name      = try reader.readInt(u16, .Little);
  const lmp_pal_subversion     = try reader.readInt(u16, .Little);
  return .{.read_local_version = .{
    .error_code         = error_code,
    .hci_version        = hci_version,
    .hci_revision       = hci_revision,
    .lmp_pal_version    = lmp_pal_version,
    .manufacturer_name  = manufacturer_name,
    .lmp_pal_subversion = lmp_pal_subversion,
  }};
}

fn receive_return_parameters_read_buffer_size_v1(reader: Reader) !ReturnParameters {
  const error_code                 = try reader.readEnum(ErrorCode, .Little);
  const acl_data_packet_length     = try reader.readInt(u16, .Little);
  const total_num_acl_data_packets = try reader.readByte();
  return .{.read_buffer_size_v1    = .{
    .error_code                 = error_code,
    .acl_data_packet_length     = acl_data_packet_length,
    .total_num_acl_data_packets = total_num_acl_data_packets
  }};
}

fn receive_return_parameters_reset(reader: Reader) !ReturnParameters {
  const error_code = try reader.readEnum(ErrorCode, .Little);
  return .{.reset  = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_random_address(reader: Reader) !ReturnParameters {
  const error_code                 = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_random_address  = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_advertising_parameters(reader: Reader) !ReturnParameters {
  const error_code                        = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_advertising_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_advertising_data(reader: Reader) !ReturnParameters {
  const error_code                  = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_advertising_data = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_advertising_enable(reader: Reader) !ReturnParameters {
  const error_code                 = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_advertising_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_scan_parameters(reader: Reader) !ReturnParameters {
  const error_code              = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_scan_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_le_set_scan_enable(reader: Reader) !ReturnParameters {
  const error_code          = try reader.readEnum(ErrorCode, .Little);
  return .{.le_set_scan_enable = .{.error_code = error_code}};
}

// fn receive_return_parameters_le_create_connection(reader: Reader) !ReturnParameters {
//   _ = reader; // no params for this command
//   return .{.le_create_connection = .{}};
// }

fn receive_return_parameters_le_create_connection_cancel(reader: Reader) !ReturnParameters {
  const error_code                   = try reader.readEnum(ErrorCode, .Little);
  return .{.le_create_connection_cancel = .{.error_code = error_code}};
}

fn receive_return_parameters_write_default_link_policy_settings(reader: Reader) !ReturnParameters {
  const error_code                             = try reader.readEnum(ErrorCode, .Little);
  return .{.write_default_link_policy_settings = .{.error_code = error_code}};
}

fn receive_return_parameters_write_local_name(reader: Reader) !ReturnParameters {
  const error_code           = try reader.readEnum(ErrorCode, .Little);
  return .{.write_local_name = .{.error_code = error_code}};
}

fn receive_return_parameters_read_local_name(reader: Reader) !ReturnParameters {
  const error_code          = try reader.readEnum(ErrorCode, .Little);
  return .{.read_local_name = .{.error_code = error_code}};
}

fn receive_return_parameters_write_page_timeout(reader: Reader) !ReturnParameters {
  const error_code             = try reader.readEnum(ErrorCode, .Little);
  return .{.write_page_timeout = .{.error_code = error_code}};
}

fn receive_return_parameters_write_scan_enable(reader: Reader) !ReturnParameters {
  const error_code             = try reader.readEnum(ErrorCode, .Little);
  return .{.write_scan_enable  = .{.error_code = error_code}};
}

fn receive_return_parameters_write_class_of_device(reader: Reader) !ReturnParameters {
  const error_code                = try reader.readEnum(ErrorCode, .Little);
  return .{.write_class_of_device = .{.error_code = error_code}};
}

fn receive_return_parameters_write_synchronous_flow_control_enable(reader: Reader) !ReturnParameters {
  const error_code                                = try reader.readEnum(ErrorCode, .Little);
  return .{.write_synchronous_flow_control_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_write_inquiry_mode(reader: Reader) !ReturnParameters {
  const error_code             = try reader.readEnum(ErrorCode, .Little);
  return .{.write_inquiry_mode = .{.error_code = error_code}};
}

fn receive_return_parameters_write_extended_inquiry_response(reader: Reader) !ReturnParameters {
  const error_code                          = try reader.readEnum(ErrorCode, .Little);
  return .{.write_extended_inquiry_response = .{.error_code = error_code}};
}

fn receive_return_parameters_write_simple_pairing_mode(reader: Reader) !ReturnParameters {
  const error_code                          = try reader.readEnum(ErrorCode, .Little);
  return .{.write_extended_inquiry_response = .{.error_code = error_code}};
}

fn receive_return_parameters_write_default_erroneous_data_reporting(reader: Reader) !ReturnParameters {
  const error_code                                 = try reader.readEnum(ErrorCode, .Little);
  return .{.write_default_erroneous_data_reporting = .{.error_code = error_code}};
}

fn receive_return_parameters_write_le_host_support(reader: Reader) !ReturnParameters {
  const error_code                = try reader.readEnum(ErrorCode, .Little);
  return .{.write_le_host_support = .{.error_code = error_code}};
}

fn receive_return_parameters_write_secure_connections_host_support(reader: Reader) !ReturnParameters {
  const error_code                                = try reader.readEnum(ErrorCode, .Little);
  return .{.write_secure_connections_host_support = .{.error_code = error_code}};
}

// helper to receive the  rest of a packet in an unhandled state
fn drain(reader: Reader, amount: u8) !void {
  var i:u8 = 0;
  while(i < amount):(i = i + 1) {
    const b = try reader.readByte();
    std.log.warn("unknown byte={x:0>2}", .{b});
  }
  return Error.UnhandledData;
}