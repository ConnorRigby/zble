const std = @import("std");

pub const SetRandomAddress = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x5;
// Opcode
pub const OPC: u16 = 0x520;

// fields: 
// * random_address

// payload length
length: usize,
pub fn init() SetRandomAddress {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetRandomAddress, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding SetRandomAddress

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetRandomAddress {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetRandomAddress decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetRandomAddress.decode(&payload);
  _ = decoded;
  std.log.warn("unimplemented", .{});
}

test "SetRandomAddress encode" {
  const set_random_address = SetRandomAddress.init();
  const encoded = try SetRandomAddress.encode(set_random_address, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
