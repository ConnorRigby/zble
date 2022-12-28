const std = @import("std");

pub const SetRandomAddress = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0x5;
// Opcode
pub const OPC: u16 = 0x2005;

// fields: 
// * random_address

// encode from a struct
pub fn encode(self: SetRandomAddress) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetRandomAddress {
  _ = payload;
  return .{};
}

test "SetRandomAddress decode" {
  const payload = [_]u8 {};
  const decoded = SetRandomAddress.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetRandomAddress encode" {
  const set_random_address = .{};
  const encoded = SetRandomAddress.encode(set_random_address);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
