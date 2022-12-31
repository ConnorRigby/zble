const std = @import("std");

const HCI = @import("../hci.zig");
const Packet = HCI.Packet;

const Reader = @import("reader.zig");
const Writer = std.fs.File.Writer;

const Self = @This();

allocator: std.mem.Allocator,
reader: std.fs.File.Reader,
writer: std.fs.File.Writer,

pub fn init(
  allocator: std.mem.Allocator,
  reader: std.fs.File.Reader, 
  writer: std.fs.File.Writer
) Self {
  return .{
    .allocator = allocator,
    .reader = reader, 
    .writer = writer
  };
}

pub fn write(self: *Self, packet: Packet) !void {
  const encoded = try packet.encode(self.allocator);
  defer self.allocator.free(encoded);
  
  var buffer = try self.allocator.alloc(u8, 257);
  defer self.allocator.free(buffer);
  std.mem.set(u8, buffer, 0);

  buffer[0] = 0x01;
  std.mem.copy(u8, buffer[1..], encoded);

  var full_command_to_send = buffer[0..encoded.len + 1];
  try self.writer.writeAll(full_command_to_send);
}

pub fn receive(self: *Self) !Packet {
  return Reader.receive(self.reader);
}