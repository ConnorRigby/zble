const std = @import("std");
const L2CAP = @import("../l2cap.zig");
const ATT   = @import("../att.zig");

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

  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .FirstNonFlushable  => writer.print("FirstNonFlushable",   .{}),
      .ContinuingFragment => writer.print("ContinuingFragment",  .{}),
      .FirstFlushable     => writer.print("FirstFlushable",      .{}),
      .Complete           => writer.print("Complete",            .{})
    };
  }
};

pub const BroadcastFlag = enum(u2) {
  PointToPoint   = 0b00,
  BREDRBroadcast = 0b01,
  Reserved10     = 0b10,
  Reserved11     = 0b11,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .PointToPoint   => writer.print("PointToPoint",   .{}),
      .BREDRBroadcast => writer.print("BREDRBroadcast", .{}),
      else            => writer.print("[reserved]",     .{}),
    };
  }
};

pub const Flags = packed struct {
  pb: PacketBoundryFlag, bc: BroadcastFlag,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return writer.print("Flags{{{any},{any}}}", .{value.pb, value.bc});
  }
};

pub const Header = packed struct {
  handle: u12,
  flags: Flags,
  length: u16,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return writer.print("Header{{{d},{any},{d}}}", .{value.handle, value.flags, value.length});
  }
};

pub const DataType = enum {
  l2cap,
  unk
};

pub const PDU = struct {
  header: Header,
  data: union(DataType) {
    l2cap: L2CAP,
    unk: [27]u8
  },
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value.data) {
      .l2cap => |l2cap| writer.print("ACL{{{any}, {any}}}", .{value.header, l2cap}),
      .unk   => |unk  | writer.print("ACL{{{any}, {any}}}", .{value.header, unk})
    };
  }

  // T = packed struct(u16){ a: u3, b: u7, c: u6 }; 
  // var st = T{ .a = 1, .b = 2, .c = 4 }; 
  // st.b = 0x7f; 
  // writePackedInt(u7, std.mem.asBytes(&st), @bitOffsetOf(T, "b"), 0x7f, builtin.cpu.arch.endian()); 

  pub fn encode(pdu: @This(), allocator: std.mem.Allocator) ![]u8 {
    var payload = try allocator.alloc(u8, 31);
    std.mem.set(u8, payload, 0);
    std.mem.writeInt(u32, payload[0..4], @bitCast(u32, pdu.header), .Little);
    switch(pdu.data) {
      .l2cap => |l2cap| {
        std.mem.writeInt(u32, payload[4..8], @bitCast(u32, l2cap.header), .Little);
        switch(l2cap.data) {
          .att => |att| {
            std.mem.writeInt(u8, payload[8..9], @enumToInt(@as(ATT.Command, att.cmd)), .Little);
            switch(att.cmd) {
              // .error_response => |error_response|
              // .exchange_mtu_request => |exchange_mtu_request|
              .exchange_mtu_response => |exchange_mtu_response| std.mem.writeInt(u16, payload[9..11], exchange_mtu_response.server_rx_mtu, .Little),
              // .execute_write_request => |execute_write_request|
              // .execute_write_response => |execute_write_response|
              // .find_by_type_value_request => |find_by_type_value_request|
              // .find_by_type_value_response => |find_by_type_value_response|
              // .find_information_request => |find_information_request|
              // .find_information_response => |find_information_response|
              // .handle_value_indication => |handle_value_indication|
              // .handle_value_confirmation => |handle_value_confirmation|
              // .prepare_write_request => |prepare_write_request|
              // .prepare_write_response => |prepare_write_response|
              // .read_blob_request => |read_blob_request|
              // .read_blob_response => |read_blob_response|
              // .read_by_type_request => |read_by_type_request|
              // .read_by_type_response => |read_by_type_response|
              // .read_by_group_type_request => |read_by_group_type_request|
              // .read_by_group_type_response => |read_by_group_type_response|
              // .read_request => |read_request|
              // .read_response => |read_response|
              // .handle_value_notification => |handle_value_notification|
              // .write_command => |write_command|
              // .write_request => |write_request|
              // .write_response => |write_response|
              inline else => |cmd| @panic("encoding not implemented for " ++ @typeName(@TypeOf(cmd)))
            }
          },
          .unk => @panic("undefined L2CAP data"),
        }
      },
      .unk => @panic("undefined PDU data"),
    }

    return payload;
  }
};

test "encode att" {
  const handle = 1;
  const cid    = 0x0004; 
  const response: PDU = .{
    .header = .{
      .length = 7,
      .handle = handle, 
      .flags  = .{.pb = .FirstNonFlushable, .bc = .PointToPoint}
    },
    .data = .{
      .l2cap = .{
        .header = .{
          .length = 3,
          .cid = cid
        },
        .data = .{
          .att = .{.cmd = .{.exchange_mtu_response = .{.server_rx_mtu = 23}}}
        },
      }
    }
  };
  var encoded = try response.encode(std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  
  // acl handle
  try std.testing.expect(encoded[0] == 0x01);
  try std.testing.expect(encoded[1] == 0x00);
  // acl len
  try std.testing.expect(encoded[2] == 0x07);
  try std.testing.expect(encoded[3] == 0x00);
  // att len
  try std.testing.expect(encoded[4] == 0x03);
  try std.testing.expect(encoded[5] == 0x00);
  // att cid
  try std.testing.expect(encoded[6] == 0x04);
  try std.testing.expect(encoded[7] == 0x00);
  // att op = 0x03
  try std.testing.expect(encoded[8] == 0x03);
  // server mtu = 23
  try std.testing.expect(encoded[9] == 23);
  try std.testing.expect(encoded[10] == 0x00);
}

test "unparsed" {
  //                   [handle    ] [length    ] [length   ] [cid      ] [op  ] [client_rx]
  var payload = [_]u8 { 0x01,0x20,   0x07,0x00,   0x03,0x00,  0x04,0x00,  0x02,  0x0f,0x02};
  const header = @bitCast(Header, payload[0..4].*);
  var data = std.mem.zeroes([27]u8);
  for(data)|_,i| {
    if(i == header.length) break;
    if(i > header.length) @panic("fixme");
    data[i] = payload[4+i];
  }
  const acl: PDU = .{
    .header = header,
    .data   = .{.unk = data}
  };

  try std.testing.expect(acl.header.handle == 1);
  try std.testing.expect(acl.header.flags.bc == .PointToPoint);
  try std.testing.expect(acl.header.flags.pb == .FirstFlushable);
  try std.testing.expect(acl.header.length == 7);
  try std.testing.expect(acl.data.unk[0] == 3);
  try std.testing.expect(acl.data.unk[1] == 0);
  try std.testing.expect(acl.data.unk[2] == 4);
  try std.testing.expect(acl.data.unk[3] == 0);
  try std.testing.expect(acl.data.unk[4] == 2);
  try std.testing.expect(acl.data.unk[5] == 0x0f);
  try std.testing.expect(acl.data.unk[6] == 0x02);
}

test "l2cap" {
  var payload = [_]u8 {0x01,0x20,0x07,0x00,0x03,0x00,0x04,0x00,0x02,0x0f,0x02};
  const header = @bitCast(Header, payload[0..4].*);
  var data = std.mem.zeroes([27]u8);
  for(data)|_,i| {
    if(i == header.length) break;
    data[i] = payload[4+i];
  }
  var l2cap_header = @bitCast(L2CAP.Header, data[0..4].*);
  var l2cap_data = std.mem.zeroes([23]u8);
  for(l2cap_data)|_,i| {
    if(i == l2cap_header.length) break;
    l2cap_data[i] = data[@sizeOf(L2CAP.Header)+i];
  }
  
  const acl: PDU = .{
    .header = header,
    .data   = .{.l2cap = .{.header = l2cap_header, .data = .{.unk = l2cap_data}}}
  };

  try std.testing.expect(acl.data.l2cap.header.length == 3);
  try std.testing.expect(acl.data.l2cap.header.cid    == 4);
  try std.testing.expect(acl.data.l2cap.data.unk[0]   == 0x02);
  try std.testing.expect(acl.data.l2cap.data.unk[1]   == 0x0f);
  try std.testing.expect(acl.data.l2cap.data.unk[2]   == 0x02);
}