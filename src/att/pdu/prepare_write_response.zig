const ATT = @import("../../att.zig");

pub const Opcode = 0x17;
handle: ATT.Handle,
offset: u16,
value: []u8,