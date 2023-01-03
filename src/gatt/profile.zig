const fdt = @import("fdt");

const Service = struct {
  uuid: packed union {uuid16: u16, uuid128: u128},
  characteristics: []struct {
    uuid: packed union {uuid16: u16, uuid128: u128},
    properties: packed union {named: packed struct {unused: u8}, unnamed: u8},
  }
};

pub fn fromDTB(dtb: []u8) @This() {
  const fdt_data = fdt.Reader.read(dtb);
  return .{};
}