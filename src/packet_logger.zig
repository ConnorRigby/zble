const std = @import("std");
const log = std.log.scoped(.hci_logger);

const zble = @import("zble.zig");
const Context = zble.Context;
const Packet = @import("hci.zig").Packet;

pub fn handler(ptr: ?*anyopaque, ctx: *Context, packet: *const Packet) void {
  _ = ptr;
  // var self = @ptrCast(*@This(), @alignCast(@alignOf(*@This()), ptr.?));
  // _ = self;
  _ = ctx;
  log.debug("<===={any}", .{packet.*});
}

pub fn outHandler(ptr: ?*anyopaque, ctx: *Context, packet: *[]u8) void {
  _ = ptr;
  // var self = @ptrCast(*@This(), @alignCast(@alignOf(*@This()), ptr.?));
  // _ = self;
  _ = ctx;
  log.debug("====>{any}", .{packet.*});
}

pub fn attachContext(self: *@This(), ctx: *Context) !void {
  try ctx.attach(.{.ptr = self, .callback = handler, .outHandler = outHandler});
}
