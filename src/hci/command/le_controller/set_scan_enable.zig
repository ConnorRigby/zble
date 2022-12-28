const std = @import("std");

pub const SetScanEnable = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0xC;
// Opcode
pub const OPC: u16 = 0x200C;

// fields: 
// * filter_duplicates
// * le_scan_enable

// encode from a struct
pub fn encode(self: SetScanEnable) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) SetScanEnable {
  _ = payload;
  return .{};
}

test "SetScanEnable decode" {
  const payload = [_]u8 {};
  const decoded = SetScanEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetScanEnable encode" {
  const set_scan_enable = .{};
  const encoded = SetScanEnable.encode(set_scan_enable);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
