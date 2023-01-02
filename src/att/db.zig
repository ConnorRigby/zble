/// Handles the ATT database

const std = @import("std");

const zble = @import("../zble.zig");
const Context = zble.Context;
const Packet = zble.HCI.Packet;

const Self = @This();

pub const UUIDType = enum {
  short,
  long
};

pub const UUID = union(UUIDType) {
  short: u16,
  long:  u128
};

pub const Handle = u16;

pub const Attribute = struct {
  uuid:   UUID,
  handle: Handle,
  value:  []u8
};

const AttributeDB = std.ArrayListUnmanaged(Attribute);

allocator: std.mem.Allocator,
handle:    u16,
db:        AttributeDB,

pub fn init(
  allocator: std.mem.Allocator,
  capacity:  usize
) !Self {
  var db = try AttributeDB.initCapacity(allocator, capacity);
  errdefer db.deinit(allocator);
  // start handle at 0, even tho 0 isn't 
  // technically a valid handle
  return .{
    .allocator = allocator,
    .handle    = 0,
    .db        = db
  };
}

pub fn deinit(self: *Self) void {
  for(self.db.items) |attribute| {
    self.allocator.free(attribute.value);
  }
  self.db.deinit(self.allocator);
}

pub fn registerAttribute(self: *Self, uuid: UUID, length: usize) !Handle {
  // TODO: check overflow
  var handle = self.handle + 1;

  // TODO: check length versus mtu
  var value = try self.allocator.alloc(u8, length);
  errdefer self.allocator.free(value);
  
  // zero the buffer
  std.mem.set(u8, value, 0);

  try self.db.append(self.allocator, .{
    .uuid   = uuid,
    .handle = handle,
    .value  = value,
  });
  
  // next handle
  self.handle = handle;
  return handle;
}

pub fn readAttributebyHandle(self: *Self, handle: Handle) ?[]u8 {
  for(self.db.items) |attribute| {
    if(attribute.handle == handle) return attribute.value;
  }
  return null;
}

pub fn writeAttributeByHandle(self: *Self, handle: Handle, value: []u8) !void {
  for(self.db.items) |attribute| {
    if(attribute.handle == handle) {
      std.mem.copy(u8, attribute.value, value);
      return;
    }
  }
  // TODO: error condition
  unreachable;
}

test {
  const ATTDB = @This();

  var db = try ATTDB.init(std.testing.allocator, 1);
  defer db.deinit();

  var handle = try db.registerAttribute(.{.short = 0xab}, 5);
  try std.testing.expect(handle == @as(Handle, 1));

  var value = [5]u8{'a', 'b', 'c', 'd', 'e'};
  try db.writeAttributeByHandle(handle, &value);

  var data = db.readAttributebyHandle(handle).?;
  try std.testing.expect(data[0] == 'a');
  try std.testing.expect(data[1] == 'b');
  try std.testing.expect(data[2] == 'c');
  try std.testing.expect(data[3] == 'd');
  try std.testing.expect(data[4] == 'e');
}