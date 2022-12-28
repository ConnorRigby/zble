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
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x1A;
// Opcode
pub const OPC: u16 = 0xC1A;

// fields: 
// * scan_enable

// encode from a struct
pub fn encode(self: WriteScanEnable) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteScanEnable {
  _ = payload;
  return .{};
}

test "WriteScanEnable decode" {
  const payload = [_]u8 {};
  const decoded = WriteScanEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteScanEnable encode" {
  const write_scan_enable = .{};
  const encoded = WriteScanEnable.encode(write_scan_enable);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
