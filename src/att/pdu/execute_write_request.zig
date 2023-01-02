pub const Opcode = 0x18;
pub const Flags = enum(u8) {
  cancel = 0x00,
  write  = 0x01,
  _
};
flags: Flags,