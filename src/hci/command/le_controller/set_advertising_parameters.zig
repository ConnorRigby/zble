const std = @import("std");

pub const SetAdvertisingParameters = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0x6;
// Opcode
pub const OPC: u16 = 0x620;

// fields: 
// * advertising_channel_map
// * advertising_filter_policy
// * advertising_interval_max
// * advertising_interval_min
// * advertising_type
// * own_address_type
// * peer_address
// * peer_address_type

// payload length
length: usize,
pub fn init() SetAdvertisingParameters {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetAdvertisingParameters, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding SetAdvertisingParameters

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetAdvertisingParameters {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetAdvertisingParameters decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetAdvertisingParameters.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetAdvertisingParameters encode" {
  const set_advertising_parameters = SetAdvertisingParameters.init();
  const encoded = try SetAdvertisingParameters.encode(set_advertising_parameters, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
