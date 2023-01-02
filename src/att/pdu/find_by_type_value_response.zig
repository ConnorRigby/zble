const ATT = @import("../../att.zig");

pub const Opcode = 0x07;
pub const HandleInformationListEntry = struct {
  found_attribute_handle: ATT.Handle,
  group_end_handle: ATT.Handle
};

handles_information_list: []HandleInformationListEntry,
