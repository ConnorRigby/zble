const std = @import("std");

pub const SetScanParameters = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xB;
// Opcode
pub const OPC: u16 = 0xB20;

// fields: 
// * le_scan_interval
// * le_scan_type
// * le_scan_window
// * own_address_type
// * scanning_filter_policy

// payload length
length: usize,
pub fn init() SetScanParameters {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetScanParameters, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding SetScanParameters

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetScanParameters {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetScanParameters decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetScanParameters.decode(&payload);
  _ = decoded;
  std.log.warn("unimplemented", .{});
}

test "SetScanParameters encode" {
  const set_scan_parameters = SetScanParameters.init();
  const encoded = try SetScanParameters.encode(set_scan_parameters, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
