const std = @import("std");

pub const SetAdvertisingEnable = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xA;
// Opcode
pub const OPC: u16 = 0xA20;

// fields: 
advertising_enable: bool,

// payload length
length: usize,
pub fn init() SetAdvertisingEnable {
  return .{.length = 4, .advertising_enable = false};
}

// encode from a struct
pub fn encode(self: SetAdvertisingEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 1;
  command[3] = @boolToInt(self.advertising_enable);
  return command;
}

test "SetAdvertisingEnable encode" {
  const set_advertising_enable = SetAdvertisingEnable.init();
  const encoded = try SetAdvertisingEnable.encode(set_advertising_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
