// HCI packet structure
// Volume 4 of the Bluetooth Spec

pub const Command = @import("hci/command.zig");
// pub const ACL     = @import("hci/acl.zig");
// pub const Sync    = @import("hci/sync.zig");
pub const Event   = @import("hci/event.zig");
// pub const ISO     = @import("hci/iso.zig");

pub const PacketType = enum(u8) {
  Command = 0x01,
  ACL     = 0x02,
  Sync    = 0x03,
  Event   = 0x04,
  ISO     = 0x05
};

pub const Packet = union(PacketType) {
  command: Command,
  // acl:     ACL,
  // sync:    Sync,
  event:   Event,
  // iso:     ISO
};
