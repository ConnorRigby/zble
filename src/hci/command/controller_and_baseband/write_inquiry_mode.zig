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
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x45;
// Opcode
pub const OPC: u16 = 0x450C;

// payload length
length: usize,
pub fn init() WriteInquiryMode {
  return .{.length = 3};
}

// fields: 
// * inquiry_mode

// encode from a struct
pub fn encode(self: WriteInquiryMode, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteInquiryMode

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteInquiryMode {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteInquiryMode decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteInquiryMode.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteInquiryMode encode" {
  const write_inquiry_mode = .{.length = 3};
  const encoded = try WriteInquiryMode.encode(write_inquiry_mode, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
