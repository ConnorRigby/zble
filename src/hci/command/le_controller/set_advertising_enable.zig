const std = @import("std");

pub const SetAdvertisingEnable = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0xA;
// Opcode
pub const OPC: u16 = 0x200A;

// fields: 
// * advertising_enable

// encode from a struct
pub fn encode(self: SetAdvertisingEnable) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingEnable {
  _ = payload;
  return .{};
}

test "SetAdvertisingEnable decode" {
  const payload = [_]u8 {};
  const decoded = SetAdvertisingEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingEnable encode" {
  const set_advertising_enable = .{};
  const encoded = SetAdvertisingEnable.encode(set_advertising_enable);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
