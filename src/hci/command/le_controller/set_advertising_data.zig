const std = @import("std");

pub const SetAdvertisingData = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x8;
// Opcode
pub const OPC: u16 = 0x820;

// fields: 
// * advertising_data

// payload length
length: usize,
pub fn init() SetAdvertisingData {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetAdvertisingData, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding SetAdvertisingData

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingData {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetAdvertisingData decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetAdvertisingData.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingData encode" {
  const set_advertising_data = SetAdvertisingData.init();
  const encoded = try SetAdvertisingData.encode(set_advertising_data, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
