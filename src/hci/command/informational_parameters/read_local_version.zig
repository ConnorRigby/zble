const std = @import("std");

pub const ReadLocalVersion = @This();

// Group Code
pub const OGF: u6  = 0x4;
// Command Code
pub const OCF: u10 = 0x1;
// Opcode
pub const OPC: u16 = 0x110;

// payload length
length: usize,
pub fn init() ReadLocalVersion {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: ReadLocalVersion, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 0;
  return command;
}

test "ReadLocalVersion encode" {
  const read_local_version = ReadLocalVersion.init();
  const encoded = try ReadLocalVersion.encode(read_local_version, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 0);
}
