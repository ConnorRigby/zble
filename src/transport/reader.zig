const std = @import("std");
const Reader = std.fs.File.Reader;


const HCI = @import("../hci.zig");
const Event            = HCI.Event;
const ReturnParameters = Event.CommandComplete.ReturnParameters;
const ErrorCode        = Event.CommandComplete.ErrorCode;
const PacketType       = HCI.PacketType;
const Packet           = HCI.Packet;
const Opcode           = HCI.Command.OPC;

pub const Error = error {
  NotImplemented, // stub implementation
  UnhandledData   // unhandled error
};

/// receives a single HCI packet
pub fn receive(reader: Reader) !Packet {
  while(true) {
    const packet_type = try reader.readEnum(PacketType, .Little);
    switch(packet_type) {
      .command => return receive_command(reader),
      .acl     => return receive_acl(reader),
      .sync    => return receive_sync(reader),
      .event   => return receive_event(reader),
      .iso     => return receive_iso(reader)
    }
  }
  unreachable;
}

fn receive_command(reader: Reader) !Packet {
  _ = reader;
  // TODO: implement receiving Command packets
  return Error.NotImplemented;
}

fn receive_acl(reader: Reader) !Packet {
  _ = reader;
  // TODO: implement receiving ACL packets
  return Error.NotImplemented;
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
    .le_meta                => receive_le_meta(reader)
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
    _ = reader;
  // TODO: implement receiving receive_le_meta packets
  return Error.NotImplemented;
}

fn receive_return_parameters(reader: Reader, command_opcode: Opcode, length: u8) !ReturnParameters {
  _ = length;
  return switch(command_opcode) {
    .set_event_mask                         => receive_return_parameters_set_event_mask(reader),
    .read_local_version                     => receive_return_parameters_read_local_version(reader),
    .read_buffer_size_v1                    => receive_return_parameters_read_buffer_size_v1(reader),
    .reset                                  => receive_return_parameters_reset(reader),
    .set_random_address                     => receive_return_parameters_set_random_address(reader),
    .set_advertising_parameters             => receive_return_parameters_set_advertising_parameters(reader),
    .set_advertising_data                   => receive_return_parameters_set_advertising_data(reader),
    .set_advertising_enable                 => receive_return_parameters_set_advertising_enable(reader),
    .set_scan_parameters                    => receive_return_parameters_set_scan_parameters(reader),
    .set_scan_enable                        => receive_return_parameters_set_scan_enable(reader),
    // .create_connection                      => receive_return_parameters_create_connection(reader),
    .create_connection_cancel               => receive_return_parameters_create_connection_cancel(reader),
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

fn receive_return_parameters_set_random_address(reader: Reader) !ReturnParameters {
  const error_code             = try reader.readEnum(ErrorCode, .Little);
  return .{.set_random_address = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_parameters(reader: Reader) !ReturnParameters {
  const error_code                     = try reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_data(reader: Reader) !ReturnParameters {
  const error_code               = try reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_data = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_enable(reader: Reader) !ReturnParameters {
  const error_code                 = try reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_set_scan_parameters(reader: Reader) !ReturnParameters {
  const error_code              = try reader.readEnum(ErrorCode, .Little);
  return .{.set_scan_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_set_scan_enable(reader: Reader) !ReturnParameters {
  const error_code          = try reader.readEnum(ErrorCode, .Little);
  return .{.set_scan_enable = .{.error_code = error_code}};
}

// fn receive_return_parameters_create_connection(reader: Reader) !ReturnParameters {
//   _ = reader; // no params for this command
//   return .{.create_connection = .{}};
// }

fn receive_return_parameters_create_connection_cancel(reader: Reader) !ReturnParameters {
  const error_code                   = try reader.readEnum(ErrorCode, .Little);
  return .{.create_connection_cancel = .{.error_code = error_code}};
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