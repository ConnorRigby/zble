const std = @import("std");

pub const SetAdvertisingParameters = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0x6;
// Opcode
pub const OPC: u16 = 0x2006;

// fields: 
// * advertising_channel_map
// * advertising_filter_policy
// * advertising_interval_max
// * advertising_interval_min
// * advertising_type
// * own_address_type
// * peer_address
// * peer_address_type

// encode from a struct
pub fn encode(self: SetAdvertisingParameters) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingParameters {
  _ = payload;
  return .{};
}

test "SetAdvertisingParameters decode" {
  const payload = [_]u8 {};
  const decoded = SetAdvertisingParameters.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingParameters encode" {
  const set_advertising_parameters = .{};
  const encoded = SetAdvertisingParameters.encode(set_advertising_parameters);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
