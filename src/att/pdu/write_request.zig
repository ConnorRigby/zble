const ATT = @import("../../att.zig");

pub const Opcode = 0x12;
handle: ATT.Handle,
value: []u8,
