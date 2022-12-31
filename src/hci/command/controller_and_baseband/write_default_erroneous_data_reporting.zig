const std = @import("std");

/// This command writes the Erroneous_Data_Reporting parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x5B`
/// * Opcode: `0x5B0C`
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

// fields: 
enabled: bool,

// payload length
length: usize,
pub fn init() WriteDefaultErroneousDataReporting {
  return .{
    .length = 4,
    .enabled = false
  };
}

// encode from a struct
pub fn encode(self: WriteDefaultErroneousDataReporting, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = @sizeOf(@TypeOf(self.enabled));
  command[3] = @boolToInt(self.enabled);
  return command;
}

test "WriteDefaultErroneousDataReporting encode" {
  const write_default_erroneous_data_reporting = WriteDefaultErroneousDataReporting.init();
  const encoded = try WriteDefaultErroneousDataReporting.encode(write_default_erroneous_data_reporting, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 1);
  try std.testing.expect(encoded[3] == 0);
}
