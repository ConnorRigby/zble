const ATT = @import("../../att.zig");

pub const Opcode = 0x23;
pub const Value = struct {
  handle: ATT.Handle,
  value: []u8
};
values: []Value,