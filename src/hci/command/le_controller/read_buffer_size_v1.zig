const std = @import("std");

pub const ReadBufferSizeV1 = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x2;
// Opcode
pub const OPC: u16 = 0x220;

// payload length
length: usize,
pub fn init() ReadBufferSizeV1 {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: ReadBufferSizeV1, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 0;
  return command;
}

test "ReadBufferSizeV1 encode" {
  const read_buffer_size_v1 = ReadBufferSizeV1.init();
  const encoded = try ReadBufferSizeV1.encode(read_buffer_size_v1, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 0);
}
