const std = @import("std");

pub const SetAdvertisingEnable = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xA;
// Opcode
pub const OPC: u16 = 0xA20;

// payload length
length: usize,
pub fn init() SetAdvertisingEnable {
  return .{.length = 3};
}

// fields: 
// * advertising_enable

// encode from a struct
pub fn encode(self: SetAdvertisingEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
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
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingEnable encode" {
  const set_advertising_enable = .{.length = 3};
  const encoded = try SetAdvertisingEnable.encode(set_advertising_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
