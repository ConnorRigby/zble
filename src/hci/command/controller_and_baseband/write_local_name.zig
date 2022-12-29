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
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x13;
// Opcode
pub const OPC: u16 = 0x130C;

// payload length
length: usize,
pub fn init() WriteLocalName {
  return .{.length = 3};
}

// fields: 
// * name

// encode from a struct
pub fn encode(self: WriteLocalName, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteLocalName

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteLocalName {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteLocalName decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteLocalName.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteLocalName encode" {
  const write_local_name = .{.length = 3};
  const encoded = try WriteLocalName.encode(write_local_name, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
