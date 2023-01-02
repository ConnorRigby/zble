const ATT = @import("../../att.zig");

pub const Opcode = 0x05;
pub const Format = enum(u8) {
  handle_16_bit_uuid  = 0x01,
  handle_128_bit_uuid = 0x02,
  _
};
pub const FormattedData = union(Format) {
  handle_16_bit_uuid: ATT.Handle,
  handle_128_bit_uuid: u128,
};
pub const InformationData = struct {
  handle: ATT.Handle,
  data: []FormattedData
};

format: Format,
information_data: InformationData,
