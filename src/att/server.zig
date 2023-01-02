const std = @import("std");
const log = std.log.scoped(.att_server);

const zble       = @import("../zble.zig");
const Context    = zble.Context;
const Packet     = zble.HCI.Packet;
const ATT        = zble.ATT;
const ATTCommand = ATT.Command;

const Self = @This();

pub const State = enum {
  Init,
  Connected,
};

/// Handle to the ATT database
db: *ATT.DB,
state: State,
/// Default: 23 - max size of a frame in a single ACL packet
mtu: u16,

pub fn init(db: *ATT.DB) !Self {
  return .{.state = .Init, .db = db, .mtu = 23};
}

pub fn deinit(self: *Self) void {
  _ = self;
}

fn handler(ptr: ?*anyopaque, ctx: *Context, packet: *const Packet) void {
  var self = @ptrCast(*Self, @alignCast(@alignOf(*Self), ptr.?));
  return switch(packet.*) {
    .acl => |acl| switch(acl.data) {
      .l2cap => |l2cap| switch(l2cap.data) {
        .att => |att| switch(att) {
          .cmd => |cmd| switch(cmd) {
            .exchange_mtu_request => return self.handle_exchange_mtu_request(ctx, packet),
            else => {},
          }, // else => {},
        }, else => {},
      }, else => {},
    }, else => {},
  };
}

fn handle_exchange_mtu_request(self: *Self, ctx: *Context, packet: *const Packet) void {
  const exchange_mtu_request = packet.acl.data.l2cap.data.att.cmd.exchange_mtu_request;
  log.info("Handling exchange_mtu_request: .client_rx_mtu={d}", .{exchange_mtu_request.client_rx_mtu});
  
  std.debug.assert(self.mtu <= 23); // FIXME: mtu size
  
  const response: Packet = .{.acl = .{
    .header = .{
      .length = 7,
      .handle = packet.acl.header.handle, 
      .flags  = .{.pb = .FirstNonFlushable, .bc = .PointToPoint}
    },
    .data = .{
      .l2cap = .{
        .header = .{
          .length = 3,
          .cid = packet.acl.data.l2cap.header.cid
        },
        .data = .{
          .att = .{.cmd = .{.exchange_mtu_response = .{.server_rx_mtu = self.mtu}}}
        },
      }
    }
  }};
  ctx.queue(response) catch |err| switch(err) {
    else => log.err("failed to queue exchange_mtu_response: {any}", .{err}),
  };
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