const std = @import("std");

const zble    = @import("../zble.zig");
const Context = zble.Context;
const Packet  = zble.HCI.Packet;
const ATT     = zble.ATT;

const Self = @This();

pub const State = enum {
  Init,
  Connected,
};

/// Handle to the ATT database
att: *ATT,
state: State,

pub fn init(att: *ATT) !Self {
  return .{.state = .Init, .att = att};
}

pub fn deinit(self: *Self) void {
  _ = self;
}

fn handler(ptr: ?*anyopaque, ctx: *Context, packet: *const Packet) void {
  var self = @ptrCast(*Self, @alignCast(@alignOf(*Self), ptr.?));
  _ = self;
  _ = ctx;
  _ = packet;
}

pub fn attachContext(self: *Self, ctx: *Context) !void {
  try ctx.attach(.{.ptr = self, .callback = handler});
}

pub fn runForContext(self: *Self, ctx: *Context) !void {
  _ = self;
  _ = ctx;
  // switch(self.state) {
  //   .Init => {
  //     try ctx.queue(.{.command = .{}});
  //   }
  // }
}