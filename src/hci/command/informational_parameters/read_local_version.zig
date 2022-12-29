const std = @import("std");

pub const ReadLocalVersion = @This();

// Group Code
pub const OGF: u6  = 0x4;
// Command Code
pub const OCF: u10 = 0x1;
// Opcode
pub const OPC: u16 = 0x110;

// payload length
length: usize,
pub fn init() ReadLocalVersion {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: ReadLocalVersion, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding ReadLocalVersion

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) ReadLocalVersion {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "ReadLocalVersion decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = ReadLocalVersion.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "ReadLocalVersion encode" {
  const read_local_version = .{.length = 3};
  const encoded = try ReadLocalVersion.encode(read_local_version, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
