const std = @import("std");

pub const PacketBoundryFlag = enum(u2) {
  /// First non-automatically flushable packet of a higher layer message 
  /// (start of a non-automatically flushable L2CAP PDU) from Host to Controller.
  FirstNonFlushable  = 0b00,
  /// Continuing fragmentof a higher layer message
  ContinuingFragment = 0b01,
  /// First automatically flushable packet of a higher layer message
  /// (start of an automatically flushable L2CAP PDU)
  FirstFlushable     = 0b10,
  /// A complete L2CAP PDU. Automatically flushable.
  Complete           = 0b11,
};

pub const BroadcastFlag = enum(u2) {
  PointToPoint   = 0b00,
  BREDRBroadcast = 0b01,
  Reserved10     = 0b10,
  Reserved11     = 0b11,
};

pub const Flags = packed struct {pb: PacketBoundryFlag, bc: BroadcastFlag};

pub const Header = packed struct {
  handle: u12,
  flags: Flags,
  length: u16,
};

pub const PDU = struct {
  header: Header,
  data: [27]u8,
};

test {
  var payload = [4]u8{2, 0x40, 4, 0} ++ [27]u8 {1,2,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  const header = @bitCast(Header, payload[0..4].*);

  const acl: PDU = .{
    .header = header,
    .data   = payload[4..].*
  };

  try std.testing.expect(acl.header.handle == 2);
  try std.testing.expect(acl.header.flags.bc == .PointToPoint);
  try std.testing.expect(acl.header.flags.pb == .ContinuingFragment);
  try std.testing.expect(acl.header.length == 4);
  try std.testing.expect(acl.data[0] == 1);
  try std.testing.expect(acl.data[1] == 2);
  try std.testing.expect(acl.data[2] == 3);
  try std.testing.expect(acl.data[3] == 4);
}