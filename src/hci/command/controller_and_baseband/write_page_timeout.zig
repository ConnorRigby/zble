const std = @import("std");

/// This command writes the value for the Page_Timeout configuration parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x18`
/// * Opcode: `0x180C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.16
/// 
/// The Page_Timeout configuration parameter defines the maximum time the local
/// Link Manager shall wait for a baseband page response from the remote device at
/// a locally initiated connection attempt. If this time expires and the remote
/// device has not responded to the page at baseband level, the connection attempt
/// will be considered to have failed.
/// 
/// ## Command Parameters
/// * `timeout` - N * 0.625 ms (1 Baseband slot)
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WritePageTimeout = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x18;
// Opcode
pub const OPC: u16 = 0x180C;

// fields: 
timeout: u16,

// payload length
length: usize,
pub fn init() WritePageTimeout {
  return .{
    .length = 5,
    .timeout = 0x20
  };
}

// encode from a struct
pub fn encode(self: WritePageTimeout, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 2;
  std.mem.writeInt(u16, command[3..5], self.timeout, .Little);
  return command;
}

test "WritePageTimeout encode" {
  const write_page_timeout = WritePageTimeout.init();
  const encoded = try WritePageTimeout.encode(write_page_timeout, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 2);
  const timeout = std.mem.readInt(u16, encoded[3..5], .Little);
  try std.testing.expect(timeout == write_page_timeout.timeout);
}
