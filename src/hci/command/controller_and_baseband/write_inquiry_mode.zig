const std = @import("std");

/// This command writes the Inquiry_Mode configuration parameter of the local BR/EDR Controller. See Section 6.5.
/// 
/// * OGF: `0x3`
/// * OCF: `0x45`
/// * Opcode: `0x450C`
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

// fields: 
inquiry_mode: u8,

// payload length
length: usize,
pub fn init() WriteInquiryMode {
  return .{
    .length = 4,
    .inquiry_mode = 0
  };
}

// encode from a struct
pub fn encode(self: WriteInquiryMode, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 1;
  command[3] = self.inquiry_mode;
  // TODO: implement encoding WriteInquiryMode

  return command;
}

test "WriteInquiryMode encode" {
  const write_inquiry_mode = WriteInquiryMode.init();
  const encoded = try WriteInquiryMode.encode(write_inquiry_mode, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
