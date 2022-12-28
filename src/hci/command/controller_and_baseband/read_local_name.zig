const std = @import("std");

/// The Read_Local_Name command provides the ability to read the stored user-friendly name for
/// the BR/EDR Controller. See Section 6.23 and 7.3.12 for more details
/// 
/// * OGF: `0x3`
/// * OCF: `0x14`
/// * Opcode: `<<20, 12>>`
/// 
/// ## Command Parameters
/// > None
/// 
/// ## Return Parameters
/// * `:status` - command status code
/// * `:local_name` - A UTF-8 encoded User Friendly Descriptive Name for the device
pub const ReadLocalName = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x14;
// Opcode
pub const OPC: u16 = 0xC14;

// encode from a struct
pub fn encode(self: ReadLocalName) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) ReadLocalName {
  _ = payload;
  return .{};
}

test "ReadLocalName decode" {
  const payload = [_]u8 {};
  const decoded = ReadLocalName.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadLocalName encode" {
  const read_local_name = .{};
  const encoded = ReadLocalName.encode(read_local_name);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
