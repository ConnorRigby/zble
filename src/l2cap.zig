const std = @import("std");

const ATT = @import("att.zig");

pub const Header = packed struct {
  length: u16,
  cid: u16,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return writer.print("Header{{{d},{d}}}", .{value.length, value.cid});
  }
};

pub const DataType = enum {
  // TODO: ATT shouldn'b be in the l2cap main packet def
  // since ATT payloads may be split over several l2cap packets
  att,
  unk
};

pub const Data = union(DataType) {
  // TODO: ATT shouldn'b be in the l2cap main packet def
  // since ATT payloads may be split over several l2cap packets
  att: ATT.PDU,
  unk: [23]u8,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .att => |att| writer.print("{any}", .{att}),
      .unk => |unk| writer.print("{any}", .{unk}),
    };
  }
};

header: Header,
data: Data,

pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
  return writer.print("L2CAP{{{any},{any}}}", .{value.header, value.data});
}

test {
  try std.testing.expect(@sizeOf(Header) == 4);
}

test {
  var payload = [_]u8 {0x03,0x00,0x04,0x00,0x02,0x0f,0x02};
  var l2cap_header = @bitCast(Header, payload[0..4].*);
  var l2cap_data = std.mem.zeroes([23]u8);
  for(l2cap_data)|_,i| {
    if(i == l2cap_header.length) break;
    l2cap_data[i] = payload[@sizeOf(Header)+i];
  }

  const l2cap: @This() = .{
    .header = l2cap_header,
    .data   = .{.unk = l2cap_data},
  };

  try std.testing.expect(l2cap.header.length == 3);
  try std.testing.expect(l2cap.header.cid    == 4);
  try std.testing.expect(l2cap.data.unk[0]   == 0x02);
  try std.testing.expect(l2cap.data.unk[1]   == 0x0f);
  try std.testing.expect(l2cap.data.unk[2]   == 0x02);
}

// TODO: ATT shouldn'b be in the l2cap main packet def
test "att" {
  var payload = [_]u8 {0x03,0x00,0x04,0x00,0x02,0x0f,0x02};
  var l2cap_header = @bitCast(Header, payload[0..4].*);
  var l2cap_data = std.mem.zeroes([23]u8);
  for(l2cap_data)|_,i| {
    if(i == l2cap_header.length) break;
    l2cap_data[i] = payload[@sizeOf(Header)+i];
  }

  try std.testing.expect(l2cap_header.cid == 0x04);
  
  // TODO: how to detect att cmd?
  
  const opc = @intToEnum(ATT.Opcode, std.mem.readInt(u8, l2cap_data[0..1], .Little));
  try std.testing.expect(opc == ATT.Opcode.exchange_mtu_request);
  const client_rx_mtu = std.mem.readInt(u16, l2cap_data[1..3], .Little);

  var att_pdu: ATT.PDU = .{
    .cmd = .{.exchange_mtu_request = .{.client_rx_mtu = client_rx_mtu}}
  };

  const l2cap: @This() = .{
    .header = l2cap_header,
    .data   = .{.att = att_pdu},
  };
  try std.testing.expect(l2cap.data.att.cmd.exchange_mtu_request.client_rx_mtu == 527);
}