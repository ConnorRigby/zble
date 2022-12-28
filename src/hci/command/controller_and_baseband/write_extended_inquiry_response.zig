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
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x52;
// Opcode
pub const OPC: u16 = 0xC52;

// fields: 
// * extended_inquiry_response
// * fec_required?

// encode from a struct
pub fn encode(self: WriteExtendedInquiryResponse) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteExtendedInquiryResponse {
  _ = payload;
  return .{};
}

test "WriteExtendedInquiryResponse decode" {
  const payload = [_]u8 {};
  const decoded = WriteExtendedInquiryResponse.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteExtendedInquiryResponse encode" {
  const write_extended_inquiry_response = .{};
  const encoded = WriteExtendedInquiryResponse.encode(write_extended_inquiry_response);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
