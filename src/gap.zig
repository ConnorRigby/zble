const std = @import("std");
const log = std.log.scoped(.gap);
const zble = @import("zble.zig");
const Context = zble.Context;
const HCI = zble.HCI;
const Command = HCI.Command;
const Event = HCI.Event;
const CommandComplete = Event.CommandComplete; 
const Packet = HCI.Packet;

const Self = @This();

pub const Role = enum {
  Broadcaster,
  Observer,
  Peripheral,
  Sensor
};

const Operation = enum {
  set_advertising_data,
  // set_advertising_parameters,
  set_advertising_enable,
  // stop_advertising,
  // start_scan,
  // stop_scan
};

const OperationData = union(Operation) {
  set_advertising_data: [31]u8,
  set_advertising_enable: struct {}
};

const State = enum {
  idle,
  advertising,
  // scanning,
  
};

role: Role,
state: State,
operations: std.BoundedArray(OperationData, 5),

pub fn init(role: Role) !Self {
  var operations = try std.BoundedArray(OperationData, 5).init(0);
  return .{.role       = role,
           .state      = .idle, 
           .operations = operations};
}

pub fn deinit(self: *Self) void {
  _ = self;
}

fn handler(ptr: ?*anyopaque, ctx: *Context, packet: *const Packet) void {
  var self = @ptrCast(*Self, @alignCast(@alignOf(*Self), ptr.?));
  _ = ctx;

  switch(packet.*) {
    .event => |event| switch(event) {
      .command_complete => |command_complete| switch(command_complete.return_parameters) {
        .le_set_advertising_enable => |le_set_advertising_enable| self.handle_set_advertising_enable(le_set_advertising_enable),
        .le_set_advertising_data => {},
        inline else => |_| {
          // log.debug("command_complete: {any}", .{return_parameters});
        }
      },
      inline else => |_| {},
    },
    inline else => |_| {},
  }
}

pub fn handle_set_advertising_enable(self: *Self, params: CommandComplete.ErrorCodeReturnParameters) void {
  if(params.error_code == .ok) {
    log.info("advertising started", .{});
    self.state = .advertising;
  }
}

pub fn attachContext(self: *Self, ctx: *Context) !void {
  try ctx.attach(.{.ptr = self, .callback = handler});
}

pub fn runForContext(self: *Self, ctx: *Context) !void {
  switch(self.state) {
    .idle, .advertising => {
      while(self.operations.popOrNull()) |op| {
        switch(op) {
          // TODO: make state data one packet wide
          .set_advertising_data => |value| {
            var set_advertising_data = Command.LEController.SetAdvertisingData.init();
            set_advertising_data.advertising_data = value;
            try ctx.queue(.{.command = .{.le_set_advertising_data = set_advertising_data}});
          },
          .set_advertising_enable => {
            var set_advertising_enable = Command.LEController.SetAdvertisingEnable.init();
            set_advertising_enable.advertising_enable = true;
            try ctx.queue(.{.command = .{.le_set_advertising_enable = set_advertising_enable}});
          }
        }
      }
    }
  }
}

pub fn startScan(self: *Self) void {
  _ = self;
  @panic("startScan not implemented");
}

pub fn stopScan(self: *Self) void {
  _ = self;
  @panic("stopScan not implemented");
}

pub fn startAdveretising(self: *Self) !void {
  try self.operations.append(.{.set_advertising_enable = .{}});
}

pub fn stopAdvertising(self: *Self) !void {
  _ = self;
  @panic("stopAdvertising not implemented");
}

pub fn setScanParameters(self: *Self, params: HCI.Command.LEController.SetScanParameters) !void {
  _ = self; _ = params;
  @panic("setScanParameters not implemented");
}

pub fn setAdvertisingData(self: *Self, advertising_data: [31]u8) !void {
  try self.operations.append(.{.set_advertising_data = advertising_data});
}
