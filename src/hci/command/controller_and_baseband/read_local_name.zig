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
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x14;
// Opcode
pub const OPC: u16 = 0x140C;

// payload length
length: usize,
pub fn init() ReadLocalName {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: ReadLocalName, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding ReadLocalName

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) ReadLocalName {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "ReadLocalName decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = ReadLocalName.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadLocalName encode" {
  const read_local_name = .{.length = 3};
  const encoded = try ReadLocalName.encode(read_local_name, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
