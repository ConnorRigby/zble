const std = @import("std");

pub const SetAdvertisingData = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0x8;
// Opcode
pub const OPC: u16 = 0x2008;

// fields: 
// * advertising_data

// encode from a struct
pub fn encode(self: SetAdvertisingData) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingData {
  _ = payload;
  return .{};
}

test "SetAdvertisingData decode" {
  const payload = [_]u8 {};
  const decoded = SetAdvertisingData.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingData encode" {
  const set_advertising_data = .{};
  const encoded = SetAdvertisingData.encode(set_advertising_data);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
