const std = @import("std");

pub const ReadWhiteListSize = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0xF;
// Opcode
pub const OPC: u16 = 0x200F;

// encode from a struct
pub fn encode(self: ReadWhiteListSize) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) ReadWhiteListSize {
  _ = payload;
  return .{};
}

test "ReadWhiteListSize decode" {
  const payload = [_]u8 {};
  const decoded = ReadWhiteListSize.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadWhiteListSize encode" {
  const read_white_list_size = .{};
  const encoded = ReadWhiteListSize.encode(read_white_list_size);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
