const std = @import("std");

/// The HCI_Write_Local_Name command provides the ability to modify the user- friendly name for the BR/EDR Controller.
/// 
/// * OGF: `0x3`
/// * OCF: `0x13`
/// * Opcode: `<<19, 12>>`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.11
/// 
/// ## Command Parameters
/// * `name` - A UTF-8 encoded User-Friendly Descriptive Name for the device. Up-to 248 bytes
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteLocalName = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x13;
// Opcode
pub const OPC: u16 = 0xC13;

// fields: 
// * name

// encode from a struct
pub fn encode(self: WriteLocalName) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteLocalName {
  _ = payload;
  return .{};
}

test "WriteLocalName decode" {
  const payload = [_]u8 {};
  const decoded = WriteLocalName.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteLocalName encode" {
  const write_local_name = .{};
  const encoded = WriteLocalName.encode(write_local_name);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
