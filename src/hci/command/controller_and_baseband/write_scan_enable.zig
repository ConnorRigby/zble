const std = @import("std");

/// This command writes the value for the Scan_Enable configuration parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x1A`
/// * Opcode: `0x1A0C`
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

pub const ScanEnable = enum(u8) {
  None,
  InquiryScanEnablePageScanDisable,
  InquiryScaneDisablePageScanEnable,
  InquiryScanEnablePageScanEnable,
  _
};

// fields: 
//TODO: this looks like it could be a bit field union
scan_enable: ScanEnable,

// payload length
length: usize,

pub fn init() WriteScanEnable {
  return .{
    .length = 4,
    .scan_enable = .None
  };
}

// encode from a struct
pub fn encode(self: WriteScanEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 1;
  command[3] = @enumToInt(self.scan_enable);
  return command;
}

test "WriteScanEnable encode" {
  const write_scan_enable = WriteScanEnable.init();
  const encoded = try WriteScanEnable.encode(write_scan_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 1);
  const mode = @intToEnum(ScanEnable, encoded[3]);
  try std.testing.expect(mode == .None);
}
