const std = @import("std");

pub const ReadLocalVersion = @This();

// Group Code
pub const OGF: u8  = 0x10;
// Command Code
pub const OCF: u10 = 0x1;
// Opcode
pub const OPC: u16 = 0x1001;

// encode from a struct
pub fn encode(self: ReadLocalVersion) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) ReadLocalVersion {
  _ = payload;
  return .{};
}

test "ReadLocalVersion decode" {
  const payload = [_]u8 {};
  const decoded = ReadLocalVersion.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadLocalVersion encode" {
  const read_local_version = .{};
  const encoded = ReadLocalVersion.encode(read_local_version);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
