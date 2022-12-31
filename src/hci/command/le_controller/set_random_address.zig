const std = @import("std");

pub const SetRandomAddress = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x5;
// Opcode
pub const OPC: u16 = 0x520;

handle: u8,
address: [6]u8,

// payload length
length: usize,
pub fn init() SetRandomAddress {
  return .{.length = 10, .handle = 0x0, .address = std.mem.zeroes([6]u8)};
}

// encode from a struct
pub fn encode(self: SetRandomAddress, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 7;
  command[3] = self.handle;
  std.mem.copy(u8, command[4..], &self.address);
  return command;
}

test "SetRandomAddress encode" {
  const set_random_address = SetRandomAddress.init();
  const encoded = try SetRandomAddress.encode(set_random_address, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 7);
}
