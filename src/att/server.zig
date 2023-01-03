const std = @import("std");
const log = std.log.scoped(.att_server);

const zble       = @import("../zble.zig");
const hci        = @import("../hci.zig");
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
            .exchange_mtu_request => self.handle_exchange_mtu_request(ctx, packet),
            .read_by_group_type_request => |request| switch(request.group_type) {
              .uuid16 => |uuid16| switch(uuid16) {
                0x2800 => self.discover_all_primary_services(ctx, packet),
                else => {}
              }, .uuid128 => {}
            },
            .read_by_type_request => |request| switch(request.attribute_type) {
              .uuid16 => |uuid16| switch(uuid16) {
                0x2802 => self.find_included_services(ctx, packet),
                0x2803 => self.discover_all_characteristics(ctx, packet),
                else => {}
              }, .uuid128 => {}
            }, else => {},
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

fn discover_all_primary_services(self: *Self, ctx: *Context, packet: *const Packet) void {
  _ = self;
  const read_by_group_type_request = packet.acl.data.l2cap.data.att.cmd.read_by_group_type_request;
  log.info("handling read_by_group_type_request: .start_handle={d} .end_handle={d} .uuid={any}", .{
    read_by_group_type_request.starting_handle,
    read_by_group_type_request.ending_handle,
    read_by_group_type_request.group_type
  });

  const response = att_error_response(
    packet.acl.header.handle,
    @as(ATTCommand, packet.acl.data.l2cap.data.att.cmd),
    read_by_group_type_request.starting_handle,
    .AttributeNotFound
  );

  ctx.queue(response) catch |err| switch(err) {
    else => log.err("failed to queue read_by_group_type_request: {any}", .{err}),
  };
}

fn find_included_services(self: *Self, ctx: *Context, packet: *const Packet) void {
  _ = self;
  const read_by_type_request = packet.acl.data.l2cap.data.att.cmd.read_by_type_request;
  log.info("handling read_by_type_request: .start_handle={d} .end_handle={d} .uuid={any}", .{
    read_by_type_request.starting_handle,
    read_by_type_request.ending_handle,
    read_by_type_request.attribute_type
  });

  const response = att_error_response(
    packet.acl.header.handle,
    @as(ATTCommand, packet.acl.data.l2cap.data.att.cmd),
    read_by_type_request.starting_handle,
    .AttributeNotFound
  );

  ctx.queue(response) catch |err| switch(err) {
    else => log.err("failed to queue read_by_type_request: {any}", .{err}),
  };
}

fn discover_all_characteristics(self: *Self, ctx: *Context, packet: *const Packet) void {
  _ = self;
  const read_by_type_request = packet.acl.data.l2cap.data.att.cmd.read_by_type_request;
  log.info("handling read_by_type_request: .start_handle={d} .end_handle={d} .uuid={any}", .{
    read_by_type_request.starting_handle,
    read_by_type_request.ending_handle,
    read_by_type_request.attribute_type
  });

  const response = att_error_response(
    packet.acl.header.handle,
    @as(ATTCommand, packet.acl.data.l2cap.data.att.cmd),
    read_by_type_request.starting_handle,
    .AttributeNotFound
  );

  ctx.queue(response) catch |err| switch(err) {
    else => log.err("failed to queue read_by_type_request: {any}", .{err}),
  };
}

fn att_error_response(
  acl_handle: u12,
  request_opcode: ATTCommand,
  request_handle: ATT.Handle,
  error_code:     ATT.ErrorResponse.ErrorCode
) Packet {
  const error_response = .{
    .request_opcode = request_opcode, // 2
    .request_handle = request_handle, // 2
    .error_code     = error_code      // 1
  };

  const l2cap_data = .{.att = .{.cmd = .{
    .error_response = error_response
  }}};

  const l2cap_header = .{
    .length = 5,
    .cid    = 0x0004
  };

  return .{.acl = .{
    .header = .{
      .length = 9,
      .handle = acl_handle, 
      .flags  = .{.pb = .FirstNonFlushable, .bc = .PointToPoint}
    },
    .data = .{.l2cap = .{
      .header = l2cap_header,
      .data   = l2cap_data,
    }}
  }};
}

pub fn attachContext(self: *Self, ctx: *Context) !void {
  try ctx.attach(.{.ptr = self, .callback = handler, .outHandler = null});
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