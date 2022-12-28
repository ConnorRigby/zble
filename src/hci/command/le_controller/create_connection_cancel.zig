const std = @import("std");

pub const CreateConnectionCancel = @This();

// Group Code
pub const OGF: u8  = 0x20;
// Command Code
pub const OCF: u10 = 0xE;
// Opcode
pub const OPC: u16 = 0x200E;

// encode from a struct
pub fn encode(self: CreateConnectionCancel) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) CreateConnectionCancel {
  _ = payload;
  return .{};
}

test "CreateConnectionCancel decode" {
  const payload = [_]u8 {};
  const decoded = CreateConnectionCancel.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "CreateConnectionCancel encode" {
  const create_connection_cancel = .{};
  const encoded = CreateConnectionCancel.encode(create_connection_cancel);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
