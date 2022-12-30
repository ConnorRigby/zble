const std = @import("std");

/// The HCI_LE_Create_Connection command is used to create an ACL connection to a
/// connectable advertiser
/// 
/// Bluetooth Core Version 5.2 | Vol 4, Part E, section 7.8.12
/// 
/// * OGF: `0x8`
/// * OCF: `0xD`
/// * Opcode: `"\r "`
/// 
/// The LE_Scan_Interval and LE_Scan_Window parameters are recommendations from
/// the Host on how long (LE_Scan_Window) and how frequently (LE_Scan_Interval)
/// the Controller should scan. The LE_Scan_Window parameter shall be set to a
/// value smaller or equal to the value set for the LE_Scan_Interval parameter. If
/// both are set to the same value, scanning should run continuously.
/// 
/// The Initiator_Filter_Policy is used to determine whether the White List is
/// used. If the White List is not used, the Peer_Address_Type and the
/// Peer_Address parameters specify the address type and address of the
/// advertising device to connect to.
/// 
/// Peer_Address_Type parameter indicates the type of address used in the
/// connectable advertisement sent by the peer. The Host shall not set
/// Peer_Address_Type to either 0x02 or 0x03 if both the Host and the Controller
/// support the HCI_LE_Set_Privacy_Mode command. If a Controller that supports the
/// HCI_LE_Set_Privacy_Mode command receives the HCI_LE_Create_Connection command
/// with Peer_Address_Type set to either 0x02 or 0x03, it may use either device
/// privacy mode or network privacy mode for that peer device.
/// 
/// Peer_Address parameter indicates the Peer’s Public Device Address, Random
/// (static) Device Address, Non-Resolvable Private Address or Resolvable Private
/// Address depending on the Peer_Address_Type parameter.
/// 
/// Own_Address_Type parameter indicates the type of address being used in the
/// connection request packets.
/// 
/// The Connection_Interval_Min and Connection_Interval_Max parameters define the
/// minimum and maximum allowed connection interval. The Connection_Interval_Min
/// parameter shall not be greater than the Connection_Interval_Max parameter.
/// 
/// The Connection_Latency parameter defines the maximum allowed connection latency
/// (see [Vol 6] Part B, Section 4.5.1).
/// 
/// The Supervision_Timeout parameter defines the link supervision timeout for the
/// connection. The Supervision_Timeout in milliseconds shall be larger than (1 +
/// Connection_Latency) * Connection_Interval_Max * 2, where Connection_Interval_Max
/// is given in milliseconds. (See [Vol 6] Part B, Section 4.5.2).
/// 
/// The Min_CE_Length and Max_CE_Length parameters are informative parameters
/// providing the Controller with the expected minimum and maximum length of the
/// connection events. The Min_CE_Length parameter shall be less than or equal to
/// the Max_CE_Length parameter.
/// 
/// If the Host issues this command when another HCI_LE_Create_Connection command is
/// pending in the Controller, the Controller shall return the error code Command
/// Disallowed (0x0C).
/// 
/// If the Own_Address_Type parameter is set to 0x01 and the random address for the
/// device has not been initialized, the Controller shall return the error code
/// Invalid HCI Command Parameters (0x12).
/// 
/// If the Own_Address_Type parameter is set to 0x03, the Initiator_Filter_Policy
/// parameter is set to 0x00, the controller's resolving list did not contain a
/// matching entry, and the random address for the device has not been initialized,
/// the Controller shall return the error code Invalid HCI Command Parameters
/// (0x12).
/// 
/// If the Own_Address_Type parameter is set to 0x03, the Initiator_Filter_Policy
/// parameter is set to 0x01, and the random address for the device has not been
/// initialized, the Controller shall return the error code Invalid HCI Command
/// Parameters (0x12)
pub const CreateConnection = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xD;
// Opcode
pub const OPC: u16 = 0xD20;

// fields: 
// * connection_interval_max
// * connection_interval_min
// * connection_latency
// * initiator_filter_policy
// * le_scan_interval
// * le_scan_window
// * max_ce_length
// * min_ce_length
// * own_address_type
// * peer_address
// * peer_address_type
// * supervision_timeout

// payload length
length: usize,
pub fn init() CreateConnection {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: CreateConnection, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding CreateConnection

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) CreateConnection {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "CreateConnection decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = CreateConnection.decode(&payload);
  _ = decoded;
  std.log.warn("unimplemented", .{});
}

test "CreateConnection encode" {
  const create_connection = CreateConnection.init();
  const encoded = try CreateConnection.encode(create_connection, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
