const std = @import("std");

/// The HCI_Write_Extended_Inquiry_Response command writes the extended inquiry
/// response to be sent during the extended inquiry response procedure.
/// 
/// * OGF: `0x3`
/// * OCF: `0x52`
/// * Opcode: `0x520C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.56
/// 
/// The FEC_Required command parameter states if FEC encoding is required. The
/// extended inquiry response data is not preserved over a reset. The initial
/// value of the inquiry response data is all zero octets. The Controller shall
/// not interpret the extended inquiry response data.
/// 
/// ## Command Parameters
/// * `fec_required` - boolean to set if FEC required. Default `false`
/// * `extended_inquiry_response` - up to 240 bytes
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteExtendedInquiryResponse = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x52;
// Opcode
pub const OPC: u16 = 0x520C;

// fields: 
fec_required: bool,
extended_inquiry_response: [244]u8,

// payload length
length: usize,
pub fn init() WriteExtendedInquiryResponse {
  return .{
    .length = 248,
    .fec_required = false,
    .extended_inquiry_response = std.mem.zeroes([244]u8)
  };
}

// encode from a struct
pub fn encode(self: WriteExtendedInquiryResponse, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 241;
  command[3] = @boolToInt(self.fec_required);
  std.mem.copy(u8, command[4..], &self.extended_inquiry_response);


  return command;
}

test "WriteExtendedInquiryResponse encode" {
  const write_extended_inquiry_response = WriteExtendedInquiryResponse.init();
  const encoded = try WriteExtendedInquiryResponse.encode(write_extended_inquiry_response, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
