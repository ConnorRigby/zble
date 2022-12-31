const std = @import("std");
const AssignedNumberes = @import("../../../../assigned_numbers.zig");

pub const SetAdvertisingData = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x8;
// Opcode
pub const OPC: u16 = 0x820;

advertising_data: [31]u8,

// payload length
length: usize,
pub fn init() SetAdvertisingData {
  return .{
    .length = 3 + 31,
    .advertising_data = std.mem.zeroes([31]u8)
  };
}

// encode from a struct
pub fn encode(self: SetAdvertisingData, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 32; // length
  std.mem.copy(u8, command[3..], &self.advertising_data);
  return command;
}

test "SetAdvertisingData encode" {
  const set_advertising_data = SetAdvertisingData.init();
  const encoded = try SetAdvertisingData.encode(set_advertising_data, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 32);
}
