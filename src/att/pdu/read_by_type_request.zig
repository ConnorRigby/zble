const ATT = @import("../../att.zig");

pub const Opcode = 0x08;

starting_handle: ATT.Handle,
ending_handle: ATT.Handle,
attribute_type: ATT.AttributeType,