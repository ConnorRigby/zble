const std = @import("std");

pub const SetScanParameters = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0xB;
// Opcode
pub const OPC: u16 = 0x200B;

// fields: 
// * le_scan_interval
// * le_scan_type
// * le_scan_window
// * own_address_type
// * scanning_filter_policy

// encode from a struct
pub fn encode(self: SetScanParameters) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetScanParameters {
  _ = payload;
  return .{};
}

test "SetScanParameters decode" {
  const payload = [_]u8 {};
  const decoded = SetScanParameters.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetScanParameters encode" {
  const set_scan_parameters = .{};
  const encoded = SetScanParameters.encode(set_scan_parameters);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
