const std = @import("std");

pub const Uart = @This();

const HCI = @import("../hci.zig");

const Event            = HCI.Event;
const ReturnParameters = Event.CommandComplete.ReturnParameters;
const ErrorCode        = Event.CommandComplete.ErrorCode;
const PacketType       = HCI.PacketType;
const Packet           = HCI.Packet;
const Opcode           = HCI.Command.OPC;

pub const Reader = std.fs.File.Reader;
pub const Writer = std.fs.File.Writer;

pub const Error = error {
  NotImplemented, // stub implementation
  UnhandledData   // unhandled error
};

allocator: std.mem.Allocator,
reader: Reader,
writer: Writer,

pub fn init(
  allocator: std.mem.Allocator,
  reader: Reader, 
  writer: Writer
) Uart {
  return .{
    .allocator = allocator,
    .reader = reader, 
    .writer = writer
  };
}

pub fn write(self: *Uart, packet: Packet) !void {
  const encoded = try packet.encode(self.allocator);
  defer self.allocator.free(encoded);
  
  var buffer = try self.allocator.alloc(u8, 257);
  defer self.allocator.free(buffer);
  std.mem.set(u8, buffer, 0);

  buffer[0] = 0x01;
  std.mem.copy(u8, buffer[1..], encoded);

  var full_command_to_send = buffer[0..encoded.len + 1];
  try self.writer.writeAll(full_command_to_send);
}

// receives a single HCI packet
pub fn receive(self: *Uart) !Packet {
  while(true) {
    const packet_type = try self.reader.readEnum(PacketType, .Little);
    switch(packet_type) {
      .command => return self.receive_command(),
      .acl     => return self.receive_acl(),
      .sync    => return self.receive_sync(),
      .event   => return self.receive_event(),
      .iso     => return self.receive_iso()
    }
  }
  unreachable;
}

fn receive_command(self: *Uart) !Packet {
  _ = self;
  // TODO: implement receiving Command packets
  return Error.NotImplemented;
}

fn receive_acl(self: *Uart) !Packet {
  _ = self;
  // TODO: implement receiving ACL packets
  return Error.NotImplemented;
}

fn receive_sync(self: *Uart) !Packet {
  _ = self;
  // TODO: implement receiving sync packets
  return Error.NotImplemented;
}

fn receive_event(self: *Uart) !Packet {
  const event_type = try self.reader.readEnum(Event.Code, .Little);
  return switch(event_type) {
    .inquiry_complete       => self.receive_inquire_complete(),
    .disconnection_complete => self.receive_disconnection_complete(),
    .command_complete       => self.receive_command_complete(),
    .command_status         => self.receive_command_status(),
    .le_meta                => self.receive_le_meta()
  };
}

fn receive_iso(self: *Uart) !Packet {
  _ = self;
  // TODO: implement receiving ISO packets
  return Error.NotImplemented;
}

fn receive_inquire_complete(self: *Uart) !Packet {
    _ = self;
  // TODO: implement receiving inquire_complete packets
  return Error.NotImplemented;
}

fn receive_disconnection_complete(self: *Uart) !Packet {
    _ = self;
  // TODO: implement receiving disconnection_complete packets
  return Error.NotImplemented;
}

fn receive_command_complete(self: *Uart) !Packet {
  const length                  = try self.reader.readByte();
  const num_hci_command_packets = try self.reader.readByte();
  const command_opcode          = try self.reader.readEnum(Opcode, .Big);
  const return_parameters       = try self.receive_return_parameters(command_opcode, length);
  const command_complete        = .{
    .num_hci_command_packets = num_hci_command_packets,
    .command_opcode          = command_opcode,
    .return_parameters       = return_parameters
  };
  return .{.event = .{.command_complete = command_complete}};
}

fn receive_command_status(self: *Uart) !Packet {
    _ = self;
  // TODO: implement receiving command_status packets
  return Error.NotImplemented;
}

fn receive_le_meta(self: *Uart) !Packet {
    _ = self;
  // TODO: implement receiving receive_le_meta packets
  return Error.NotImplemented;
}

fn receive_return_parameters(self: *Uart, command_opcode: Opcode, length: u8) !ReturnParameters {
  _ = length;
  return switch(command_opcode) {
    .set_event_mask                         => self.receive_return_parameters_set_event_mask(),
    .read_local_version                     => self.receive_return_parameters_read_local_version(),
    .read_buffer_size_v1                    => self.receive_return_parameters_read_buffer_size_v1(),
    .reset                                  => self.receive_return_parameters_reset(),
    .set_random_address                     => self.receive_return_parameters_set_random_address(),
    .set_advertising_parameters             => self.receive_return_parameters_set_advertising_parameters(),
    .set_advertising_data                   => self.receive_return_parameters_set_advertising_data(),
    .set_advertising_enable                 => self.receive_return_parameters_set_advertising_enable(),
    .set_scan_parameters                    => self.receive_return_parameters_set_scan_parameters(),
    .set_scan_enable                        => self.receive_return_parameters_set_scan_enable(),
    // .create_connection                      => self.receive_return_parameters_create_connection(),
    .create_connection_cancel               => self.receive_return_parameters_create_connection_cancel(),
    .write_default_link_policy_settings     => self.receive_return_parameters_write_default_link_policy_settings(),
    .write_local_name                       => self.receive_return_parameters_write_local_name(),
    .read_local_name                        => self.receive_return_parameters_read_local_name(),
    .write_page_timeout                     => self.receive_return_parameters_write_page_timeout(),
    .write_scan_enable                      => self.receive_return_parameters_write_scan_enable(),
    .write_class_of_device                  => self.receive_return_parameters_write_class_of_device(),
    .write_synchronous_flow_control_enable  => self.receive_return_parameters_write_synchronous_flow_control_enable(),
    .write_inquiry_mode                     => self.receive_return_parameters_write_inquiry_mode(),
    .write_extended_inquiry_response        => self.receive_return_parameters_write_extended_inquiry_response(),
    .write_simple_pairing_mode              => self.receive_return_parameters_write_simple_pairing_mode(),
    .write_default_erroneous_data_reporting => self.receive_return_parameters_write_default_erroneous_data_reporting(),
    .write_le_host_support                  => self.receive_return_parameters_write_le_host_support(),
    .write_secure_connections_host_support  => self.receive_return_parameters_write_secure_connections_host_support(),
  };
}

fn receive_return_parameters_set_event_mask(self: *Uart) !ReturnParameters {
  const error_code         = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_event_mask = .{.error_code = error_code}};
}

fn receive_return_parameters_read_local_version(self: *Uart) !ReturnParameters {
  const error_code             = try self.reader.readEnum(ErrorCode, .Little);
  const hci_version            = try self.reader.readByte();
  const hci_revision           = try self.reader.readInt(u16, .Little);
  const lmp_pal_version        = try self.reader.readByte();
  const manufacturer_name      = try self.reader.readInt(u16, .Little);
  const lmp_pal_subversion     = try self.reader.readInt(u16, .Little);
  return .{.read_local_version = .{
    .error_code         = error_code,
    .hci_version        = hci_version,
    .hci_revision       = hci_revision,
    .lmp_pal_version    = lmp_pal_version,
    .manufacturer_name  = manufacturer_name,
    .lmp_pal_subversion = lmp_pal_subversion,
  }};
}

fn receive_return_parameters_read_buffer_size_v1(self: *Uart) !ReturnParameters {
  const error_code                 = try self.reader.readEnum(ErrorCode, .Little);
  const acl_data_packet_length     = try self.reader.readInt(u16, .Little);
  const total_num_acl_data_packets = try self.reader.readByte();
  return .{.read_buffer_size_v1    = .{
    .error_code                 = error_code,
    .acl_data_packet_length     = acl_data_packet_length,
    .total_num_acl_data_packets = total_num_acl_data_packets
  }};
}

fn receive_return_parameters_reset(self: *Uart) !ReturnParameters {
  const error_code = try self.reader.readEnum(ErrorCode, .Little);
  return .{.reset  = .{.error_code = error_code}};
}

fn receive_return_parameters_set_random_address(self: *Uart) !ReturnParameters {
  const error_code             = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_random_address = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_parameters(self: *Uart) !ReturnParameters {
  const error_code                     = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_data(self: *Uart) !ReturnParameters {
  const error_code               = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_data = .{.error_code = error_code}};
}

fn receive_return_parameters_set_advertising_enable(self: *Uart) !ReturnParameters {
  const error_code                 = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_advertising_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_set_scan_parameters(self: *Uart) !ReturnParameters {
  const error_code              = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_scan_parameters = .{.error_code = error_code}};
}

fn receive_return_parameters_set_scan_enable(self: *Uart) !ReturnParameters {
  const error_code          = try self.reader.readEnum(ErrorCode, .Little);
  return .{.set_scan_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_create_connection(self: *Uart) !ReturnParameters {
  _ = self; // no params for this command
  return .{.create_connection = .{}};
}

fn receive_return_parameters_create_connection_cancel(self: *Uart) !ReturnParameters {
  const error_code                   = try self.reader.readEnum(ErrorCode, .Little);
  return .{.create_connection_cancel = .{.error_code = error_code}};
}

fn receive_return_parameters_write_default_link_policy_settings(self: *Uart) !ReturnParameters {
  const error_code                             = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_default_link_policy_settings = .{.error_code = error_code}};
}

fn receive_return_parameters_write_local_name(self: *Uart) !ReturnParameters {
  const error_code           = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_local_name = .{.error_code = error_code}};
}

fn receive_return_parameters_read_local_name(self: *Uart) !ReturnParameters {
  const error_code          = try self.reader.readEnum(ErrorCode, .Little);
  return .{.read_local_name = .{.error_code = error_code}};
}

fn receive_return_parameters_write_page_timeout(self: *Uart) !ReturnParameters {
  const error_code             = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_page_timeout = .{.error_code = error_code}};
}

fn receive_return_parameters_write_scan_enable(self: *Uart) !ReturnParameters {
  const error_code             = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_scan_enable  = .{.error_code = error_code}};
}

fn receive_return_parameters_write_class_of_device(self: *Uart) !ReturnParameters {
  const error_code                = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_class_of_device = .{.error_code = error_code}};
}

fn receive_return_parameters_write_synchronous_flow_control_enable(self: *Uart) !ReturnParameters {
  const error_code                                = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_synchronous_flow_control_enable = .{.error_code = error_code}};
}

fn receive_return_parameters_write_inquiry_mode(self: *Uart) !ReturnParameters {
  const error_code             = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_inquiry_mode = .{.error_code = error_code}};
}

fn receive_return_parameters_write_extended_inquiry_response(self: *Uart) !ReturnParameters {
  const error_code                          = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_extended_inquiry_response = .{.error_code = error_code}};
}

fn receive_return_parameters_write_simple_pairing_mode(self: *Uart) !ReturnParameters {
  const error_code                          = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_extended_inquiry_response = .{.error_code = error_code}};
}

fn receive_return_parameters_write_default_erroneous_data_reporting(self: *Uart) !ReturnParameters {
  const error_code                                 = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_default_erroneous_data_reporting = .{.error_code = error_code}};
}

fn receive_return_parameters_write_le_host_support(self: *Uart) !ReturnParameters {
  const error_code                = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_le_host_support = .{.error_code = error_code}};
}

fn receive_return_parameters_write_secure_connections_host_support(self: *Uart) !ReturnParameters {
  const error_code                                = try self.reader.readEnum(ErrorCode, .Little);
  return .{.write_secure_connections_host_support = .{.error_code = error_code}};
}

// helper to receive the  rest of a packet in an unhandled state
fn drain(self: *Uart, amount: u8) !void {
  var i:u8 = 0;
  while(i < amount):(i = i + 1) {
    const b = try self.reader.readByte();
    std.log.warn("unknown byte={x:0>2}", .{b});
  }
  return Error.UnhandledData;
}