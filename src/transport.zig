// Handles reading/writing HCI and ACL packets

const std = @import("std");

pub const PhysicalLayer = struct {
  pub const recv_callback  = *const fn (*anyopaque) void;
  pub const write_callback = *const fn (*anyopaque) void;

  pub const Impl = struct {
    ptr: *anyopaque,
    recv_Fn: recv_callback,
    write_Fn: write_callback,
  };

  impl: Impl,

  pub fn init(impl: Impl) PhysicalLayer {
    return .{.impl = impl};
  }

  pub fn recv(self: *PhysicalLayer) void {
    self.impl.recv_Fn(self.impl.ptr);
  }

  pub fn write(self: *PhysicalLayer) void {
    self.impl.write_Fn(self.impl.ptr);
    @panic("write not implemented yet!");
  }
};

// pyhsical layer for testing
// panics on recv and write
pub const NullPhysicalLayer = struct {
  pub fn init() NullPhysicalLayer {
    return .{};
  }

  pub fn recv(ptr: *anyopaque) void {
    const self = @ptrCast(*NullPhysicalLayer, @alignCast(@alignOf(NullPhysicalLayer), ptr));
    _ = self;
    @panic("recv not implemented yet");
  }

  pub fn write(ptr: *anyopaque) void {
    const self = @ptrCast(*NullPhysicalLayer, @alignCast(@alignOf(NullPhysicalLayer), ptr));
    _ = self;
    @panic("write not implemented yet");
  }
};

pub const Transport = struct {
  allocator: std.mem.Allocator,
  physical_layer: PhysicalLayer,

  // initialize the transport
  pub fn init(allocator: std.mem.Allocator) !Transport {
    // TODO: must supply a physicall layer impl via args
    var impl = NullPhysicalLayer.init();

    var physical_layer = PhysicalLayer.init(.{
      .impl = &impl,
      .recv_Fn = &NullPhysicalLayer.recv,
      .write_Fn = &NullPhysicalLayer.write,
    });

    return .{
      .allocator = allocator,
      .physical_layer = physical_layer
    };
  }

  pub fn command(self: *Transport) void {
    _ = self;
  }

  pub fn acl(self: *Transport) void {
    _ = self;
  }
};