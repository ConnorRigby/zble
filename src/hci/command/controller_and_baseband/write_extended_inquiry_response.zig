const std = @import("std");

/// The HCI_Write_Extended_Inquiry_Response command writes the extended inquiry
/// response to be sent during the extended inquiry response procedure.
/// 
/// * OGF: `0x3`
/// * OCF: `0x52`
/// * Opcode: `"R\f"`
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

// payload length
length: usize,
pub fn init() WriteExtendedInquiryResponse {
  return .{.length = 3};
}

// fields: 
// * extended_inquiry_response
// * fec_required?

// encode from a struct
pub fn encode(self: WriteExtendedInquiryResponse, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 0;
  // TODO: implement encoding WriteExtendedInquiryResponse

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteExtendedInquiryResponse {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteExtendedInquiryResponse decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteExtendedInquiryResponse.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteExtendedInquiryResponse encode" {
  const write_extended_inquiry_response = .{.length = 3};
  const encoded = try WriteExtendedInquiryResponse.encode(write_extended_inquiry_response, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
