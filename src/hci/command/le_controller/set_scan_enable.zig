const std = @import("std");

pub const SetScanEnable = @This();

// Group Code
pub const OGF: u6  = 0x8;
// Command Code
pub const OCF: u10 = 0xC;
// Opcode
pub const OPC: u16 = 0xC20;

// fields: 
filter_duplicates: bool,
le_scan_enable: bool,
// * le_scan_enable

// payload length
length: usize,
pub fn init() SetScanEnable {
  return .{.length = 5, .filter_duplicates = false, .le_scan_enable = false};
}

// encode from a struct
pub fn encode(self: SetScanEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 2;
  command[3] = @boolToInt(self.filter_duplicates);
  command[4] = @boolToInt(self.le_scan_enable);
  return command;
}

test "SetScanEnable encode" {
  const set_scan_enable = SetScanEnable.init();
  const encoded = try SetScanEnable.encode(set_scan_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 2);
}
