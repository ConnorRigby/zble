const std = @import("std");

pub const ReadBufferSizeV1 = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0x2;
// Opcode
pub const OPC: u16 = 0x2002;

// encode from a struct
pub fn encode(self: ReadBufferSizeV1) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) ReadBufferSizeV1 {
  _ = payload;
  return .{};
}

test "ReadBufferSizeV1 decode" {
  const payload = [_]u8 {};
  const decoded = ReadBufferSizeV1.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadBufferSizeV1 encode" {
  const read_buffer_size_v1 = .{};
  const encoded = ReadBufferSizeV1.encode(read_buffer_size_v1);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
