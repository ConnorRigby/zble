const std = @import("std");

pub const SetScanEnable = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xC;
// Opcode
pub const OPC: u16 = 0xC20;

// fields: 
// * filter_duplicates
// * le_scan_enable

// payload length
length: usize,
pub fn init() SetScanEnable {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: SetScanEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding SetScanEnable

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) SetScanEnable {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "SetScanEnable decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = SetScanEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "SetScanEnable encode" {
  const set_scan_enable = SetScanEnable.init();
  const encoded = try SetScanEnable.encode(set_scan_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
