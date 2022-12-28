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
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x5B;
// Opcode
pub const OPC: u16 = 0xC5B;

// fields: 
// * enabled

// encode from a struct
pub fn encode(self: WriteDefaultErroneousDataReporting) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteDefaultErroneousDataReporting {
  _ = payload;
  return .{};
}

test "WriteDefaultErroneousDataReporting decode" {
  const payload = [_]u8 {};
  const decoded = WriteDefaultErroneousDataReporting.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteDefaultErroneousDataReporting encode" {
  const write_default_erroneous_data_reporting = .{};
  const encoded = WriteDefaultErroneousDataReporting.encode(write_default_erroneous_data_reporting);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
