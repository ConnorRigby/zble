const std = @import("std");

pub const CreateConnectionCancel = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xE;
// Opcode
pub const OPC: u16 = 0xE20;

// payload length
length: usize,
pub fn init() CreateConnectionCancel {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: CreateConnectionCancel, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding CreateConnectionCancel

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) CreateConnectionCancel {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "CreateConnectionCancel decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = CreateConnectionCancel.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "CreateConnectionCancel encode" {
  const create_connection_cancel = CreateConnectionCancel.init();
  const encoded = try CreateConnectionCancel.encode(create_connection_cancel, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
