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

pub fn write(self: *Self, allocator: std.mem.Allocator, packet: Packet) !void {
  const encoded = try packet.encode(allocator);
  defer allocator.free(encoded);
  
  var buffer = try allocator.alloc(u8, 257);
  defer allocator.free(buffer);
  std.mem.set(u8, buffer, 0);

  // std.debug.print("packet\n", .{});
  // for(buffer)|c,i|{std.debug.print("\nout[{d}]={x:0>2}", .{i, c});}
  // std.debug.print("/packet\n", .{});

  buffer[0] = 0x01;
  std.mem.copy(u8, buffer[1..], encoded);
  var full_command_to_send = buffer[0..encoded.len + 1];
  // std.debug.print("command\n", .{});
  // for(full_command_to_send)|c,i|{std.debug.print("\nout[{d}]={x:0>2}", .{i, c});}
  // std.debug.print("/command\n", .{});
  try self.writer.writeAll(full_command_to_send);
}

pub fn receive(self: *Self) !Packet {
  return Reader.receive(self.reader);
}