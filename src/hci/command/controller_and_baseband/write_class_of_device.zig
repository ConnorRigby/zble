const std = @import("std");

/// This command writes the value for the Class_Of_Device parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x24`
/// * Opcode: `"$\f"`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.26
/// 
/// ## Command Parameters
/// * `class` - integer for class of devic
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteClassOfDevice = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x24;
// Opcode
pub const OPC: u16 = 0xC24;

// fields: 
// * class

// encode from a struct
pub fn encode(self: WriteClassOfDevice) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteClassOfDevice {
  _ = payload;
  return .{};
}

test "WriteClassOfDevice decode" {
  const payload = [_]u8 {};
  const decoded = WriteClassOfDevice.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteClassOfDevice encode" {
  const write_class_of_device = .{};
  const encoded = WriteClassOfDevice.encode(write_class_of_device);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
