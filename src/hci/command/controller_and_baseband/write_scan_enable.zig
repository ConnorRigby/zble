const std = @import("std");

/// This command writes the value for the Scan_Enable configuration parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x1A`
/// * Opcode: `<<26, 12>>`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.18
/// 
/// The Scan_Enable parameter controls whether or not the BR/EDR Controller will
/// periodically scan for page attempts and/or inquiry requests from other BR/EDR
/// Controllers. If Page Scan is enabled, then the device will enter page scan
/// mode based on the value of the Page_Scan_Interval and Page_Scan_Window
/// parameters. If Inquiry Scan is enabled, then the BR/EDR Controller will enter
/// Inquiry Scan mode based on the value of the Inquiry_Scan_Interval and
/// Inquiry_Scan_Window parameters.
/// 
/// ## Command Parameters
/// * `scan_enable`:
///   * `0x00` - No scans enabled. **Default**.
///   * `0x01` - Inquiry Scan enabled. Page Scan disabled.
///   * `0x02` - Inquiry Scan disabled. Page Scan enabled.
///   * `0x03` - Inquiry Scan enabled. Page Scan enabled.
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteScanEnable = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x1A;
// Opcode
pub const OPC: u16 = 0x1A0C;

// payload length
length: usize,
pub fn init() WriteScanEnable {
  return .{.length = 3};
}

// fields: 
// * scan_enable

// encode from a struct
pub fn encode(self: WriteScanEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteScanEnable

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteScanEnable {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteScanEnable decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteScanEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteScanEnable encode" {
  const write_scan_enable = .{.length = 3};
  const encoded = try WriteScanEnable.encode(write_scan_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
