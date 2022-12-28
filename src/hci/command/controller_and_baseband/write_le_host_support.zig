const std = @import("std");

/// The HCI_Write_LE_Host_Support command is used to set the LE Supported (Host)
/// and Simultaneous LE and BR/EDR to Same Device Capable (Host) Link Manager
/// Protocol feature bits.
/// 
/// * OGF: `0x3`
/// * OCF: `0x6D`
/// * Opcode: `"m\f"`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.79
/// 
/// ## Command Parameters
/// * `le_supported_host_enabled` - boolean (default: false)
/// 
/// Note that this command also carries the Simultaneous_LE_Host parameter.
/// However, this parameter is not exposed in this API because it is always false.
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteLEHostSupport = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x6D;
// Opcode
pub const OPC: u16 = 0xC6D;

// fields: 
// * le_supported_host_enabled

// encode from a struct
pub fn encode(self: WriteLEHostSupport) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteLEHostSupport {
  _ = payload;
  return .{};
}

test "WriteLEHostSupport decode" {
  const payload = [_]u8 {};
  const decoded = WriteLEHostSupport.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteLEHostSupport encode" {
  const write_le_host_support = .{};
  const encoded = WriteLEHostSupport.encode(write_le_host_support);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
