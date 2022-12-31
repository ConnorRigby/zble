const std = @import("std");

pub const CreateConnectionCancel = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xE;
// Opcode
pub const OPC: u16 = 0xE20;

// payload length
length: usize,
pub fn init() CreateConnectionCancel {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: CreateConnectionCancel, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 0;
  return command;
}

test "CreateConnectionCancel encode" {
  const create_connection_cancel = CreateConnectionCancel.init();
  const encoded = try CreateConnectionCancel.encode(create_connection_cancel, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 0);
}
