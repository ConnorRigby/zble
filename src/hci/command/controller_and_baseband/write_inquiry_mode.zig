const std = @import("std");

/// This command writes the Inquiry_Mode configuration parameter of the local BR/EDR Controller. See Section 6.5.
/// 
/// * OGF: `0x3`
/// * OCF: `0x45`
/// * Opcode: `"E\f"`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.50
/// 
/// ## Command Parameters
/// * `inquiry_mode` - can be 0, 1, or 2. Default: 0
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteInquiryMode = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x45;
// Opcode
pub const OPC: u16 = 0xC45;

// fields: 
// * inquiry_mode

// encode from a struct
pub fn encode(self: WriteInquiryMode) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteInquiryMode {
  _ = payload;
  return .{};
}

test "WriteInquiryMode decode" {
  const payload = [_]u8 {};
  const decoded = WriteInquiryMode.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteInquiryMode encode" {
  const write_inquiry_mode = .{};
  const encoded = WriteInquiryMode.encode(write_inquiry_mode);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
