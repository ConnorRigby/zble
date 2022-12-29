const std = @import("std");

/// This command writes the Erroneous_Data_Reporting parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x5B`
/// * Opcode: `"[\f"`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.65
/// 
/// This command writes the Erroneous_Data_Reporting parameter. The BR/EDR
/// Controller shall set the Packet_Status_Flag as defined in Section 5.4.3 HCI
/// Synchronous Data packets, depending on the value of this parameter. The new
/// value for the Erroneous_Data_Reporting parameter shall not apply to existing
/// synchronous connections.
/// 
/// ## Command Parameters
/// * `enabled` - boolean (default: false)
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteDefaultErroneousDataReporting = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x5B;
// Opcode
pub const OPC: u16 = 0x5B0C;

// payload length
length: usize,
pub fn init() WriteDefaultErroneousDataReporting {
  return .{.length = 3};
}

// fields: 
// * enabled

// encode from a struct
pub fn encode(self: WriteDefaultErroneousDataReporting, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteDefaultErroneousDataReporting

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteDefaultErroneousDataReporting {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteDefaultErroneousDataReporting decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteDefaultErroneousDataReporting.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteDefaultErroneousDataReporting encode" {
  const write_default_erroneous_data_reporting = .{.length = 3};
  const encoded = try WriteDefaultErroneousDataReporting.encode(write_default_erroneous_data_reporting, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
