const ATT = @import("../../att.zig");

pub const Opcode = 0x16;
handle: ATT.Handle,
offset: u16,
value: []u8,
