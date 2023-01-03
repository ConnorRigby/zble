const std = @import("std");

const HCI = @import("../hci.zig");
const Packet = HCI.Packet;

const Reader = @import("reader.zig");
const Writer = std.fs.File.Writer;

const Self = @This();

reader: std.fs.File.Reader,
writer: std.fs.File.Writer,

pub fn init(
  reader: std.fs.File.Reader, 
  writer: std.fs.File.Writer
) Self {
  return .{
    .reader = reader, 
    .writer = writer
  };
}

pub fn deinit(self: *Self) void {
  _ = self;
}

pub fn drain(self: *Self, amount: u8) !void {
  try Reader.drain(self.reader, amount);
}

pub fn write(self: *Self, allocator: std.mem.Allocator, packet: Packet) ![]u8 {
  const encoded = try packet.encode(allocator);
  defer allocator.free(encoded);
  
  var buffer = try allocator.alloc(u8, 257);
  errdefer allocator.free(buffer);
  
  std.mem.set(u8, buffer, 0);
  buffer[0] = @enumToInt(@as(HCI.PacketType, packet));
  std.mem.copy(u8, buffer[1..], encoded);
  var payload = buffer[0..encoded.len + 1];
  // std.log.err("writing payload: {x}", .{std.fmt.fmtSliceHexLower(payload)});
  // 02 01000 7000 3000 4000 3 1700 0000000000000000000000000000000000000000

  try self.writer.writeAll(payload);
  return buffer;
}

pub fn receive(self: *Self) !Packet {
  return Reader.receive(self.reader);
}