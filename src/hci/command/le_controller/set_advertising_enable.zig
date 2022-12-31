const std = @import("std");

pub const SetAdvertisingEnable = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xA;
// Opcode
pub const OPC: u16 = 0xA20;

// fields: 
// * advertising_enable

// payload length
length: usize,
pub fn init() SetAdvertisingEnable {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetAdvertisingEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 0;
  // TODO: implement encoding SetAdvertisingEnable

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingEnable {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetAdvertisingEnable decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetAdvertisingEnable.decode(&payload);
  _ = decoded;
  std.log.warn("unimplemented", .{});
}

test "SetAdvertisingEnable encode" {
  const set_advertising_enable = SetAdvertisingEnable.init();
  const encoded = try SetAdvertisingEnable.encode(set_advertising_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
