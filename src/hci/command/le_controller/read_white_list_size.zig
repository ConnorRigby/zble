const std = @import("std");

pub const ReadWhiteListSize = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xF;
// Opcode
pub const OPC: u16 = 0xF20;

// payload length
length: usize,
pub fn init() ReadWhiteListSize {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: ReadWhiteListSize, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding ReadWhiteListSize

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) ReadWhiteListSize {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "ReadWhiteListSize decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = ReadWhiteListSize.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadWhiteListSize encode" {
  const read_white_list_size = .{.length = 3};
  const encoded = try ReadWhiteListSize.encode(read_white_list_size, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
