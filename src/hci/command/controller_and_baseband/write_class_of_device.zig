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
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x24;
// Opcode
pub const OPC: u16 = 0x240C;

// payload length
length: usize,
pub fn init() WriteClassOfDevice {
  return .{.length = 3};
}

// fields: 
// * class

// encode from a struct
pub fn encode(self: WriteClassOfDevice, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteClassOfDevice

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteClassOfDevice {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteClassOfDevice decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteClassOfDevice.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteClassOfDevice encode" {
  const write_class_of_device = .{.length = 3};
  const encoded = try WriteClassOfDevice.encode(write_class_of_device, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
