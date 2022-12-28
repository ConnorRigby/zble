const std = @import("std");

/// This command writes the value for the Page_Timeout configuration parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x18`
/// * Opcode: `<<24, 12>>`
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
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x18;
// Opcode
pub const OPC: u16 = 0xC18;

// fields: 
// * timeout

// encode from a struct
pub fn encode(self: WritePageTimeout) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WritePageTimeout {
  _ = payload;
  return .{};
}

test "WritePageTimeout decode" {
  const payload = [_]u8 {};
  const decoded = WritePageTimeout.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WritePageTimeout encode" {
  const write_page_timeout = .{};
  const encoded = WritePageTimeout.encode(write_page_timeout);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
