const std = @import("std");

/// This command enables Simple Pairing mode in the BR/EDR Controller.
/// 
/// * OGF: `0x3`
/// * OCF: `0x56`
/// * Opcode: `0x560C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.59
/// 
/// When Simple Pairing Mode is set to 'enabled' the Link Manager shall respond to
/// an LMP_IO_CAPABILITY_REQ PDU with an LMP_IO_CAPABILITY_RES PDU and continue
/// with the subsequent pairing procedure. When Simple Pairing mode is set to
/// 'disabled', the Link Manager shall reject an IO capability request. A Host
/// shall not set the Simple Pairing Mode to ‘disabled.’
/// 
/// Until Write_Simple_Pairing_Mode is received by the BR/EDR Controller, it shall
/// not support any Simple Pairing sequences, and shall return the error code
/// Simple Pairing not Supported by Host (0x37). This command shall be written
/// before initiating page scan or paging procedures.
/// 
/// The Link Manager Secure Simple Pairing (Host Support) feature bit shall be set
/// to the Simple_Pairing_Mode parameter. The default value for
/// Simple_Pairing_Mode shall be 'disabled.' When Simple_Pairing_Mode is set to
/// 'enabled,' the bit in the LMP features mask indicating support for Secure
/// Simple Pairing (Host Support) shall be set to enabled in subsequent responses
/// to an LMP_FEATURES_REQ from a remote device.
/// 
/// ## Command Parameters
/// * `enabled` - boolean to set if pairing mode enabled. Default `false`
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteSimplePairingMode = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x56;
// Opcode
pub const OPC: u16 = 0x560C;

// fields: 
enabled: bool,

// payload length
length: usize,
pub fn init() WriteSimplePairingMode {
  return .{
    .length = 4,
    .enabled = false
  };
}

// encode from a struct
pub fn encode(self: WriteSimplePairingMode, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 1;
  command[3] = @boolToInt (self.enabled);
  // TODO: implement encoding WriteSimplePairingMode

  return command;
}

test "WriteSimplePairingMode encode" {
  const write_simple_pairing_mode = WriteSimplePairingMode.init();
  const encoded = try WriteSimplePairingMode.encode(write_simple_pairing_mode, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
