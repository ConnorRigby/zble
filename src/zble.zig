/// ZBLE - Bluetooth Low Energy in Zig
/// Files referenced from this module
/// should be expected to remain relatively
/// stable, tho the APIs may change.
/// This file is the "root" of the library
/// and everything referenced within will
/// be part of the core API. See each root file
/// For additional doocumentation

const std = @import("std");

/// Public HCI encoder/decoder interface
pub const HCI = @import("hci.zig");
const Packet = HCI.Packet;

/// Assigned numbers as described in the official
/// specification
pub const AssignedNumbers = @import("assigned_numbers.zig");

/// Helper for assembling data for the SetAdvertisingData command
pub const AdvertisingData = @import("advertising_data.zig");

/// Generic Access Profile
pub const GAP = @import("gap.zig");

/// Attribute protocol
pub const ATT = @import("att.zig");

/// callback structure. Use to register
/// HCI packet
pub const Handler = struct {
  pub const Callback = *const fn (?*anyopaque, *Context, *const Packet) void;
  pub const OutHandler = *const fn (?*anyopaque, *Context, *[]u8) void;
  ptr: ?*anyopaque,
  callback: Callback,
  outHandler: ?OutHandler
};

/// Root Level handle to BLE operations
pub const Context = struct {
  allocator: std.mem.Allocator,
  transport: HCI.Transport.Uart,
  handlers:  std.ArrayListUnmanaged(Handler),
  in:        std.ArrayListUnmanaged(Packet),
  out:       std.ArrayListUnmanaged(Packet),

  pub fn init(
    allocator: std.mem.Allocator, 
    reader:    std.fs.File.Reader,
    writer:    std.fs.File.Writer,
  ) !Context {
    // Handles physical layer tx and rx of HCI packets
    var transport = HCI.Transport.Uart.init(
      reader,
      writer
    );
    errdefer transport.deinit();

    // Store of handlers subscribing to packets
    var handlers = try std.ArrayListUnmanaged(Handler).initCapacity(
      allocator, 3 
    );
    errdefer handlers.deinit(allocator);

    // buffer for RX'd packets
    var in = try std.ArrayListUnmanaged(Packet).initCapacity(
      allocator, 5 // TODO: this should be sized from *somewhere*
    );
    errdefer in.deinit(allocator);

    // buffer for TX'd packetss
    var out = try std.ArrayListUnmanaged(Packet).initCapacity(
      allocator, 5 // TODO: this should be sized from *somewhere*
    );
    errdefer out.deinit(allocator);

    return .{
      .allocator = allocator,
      .transport = transport,
      .handlers  = handlers,
      .in        = in, 
      .out       = out
    };
  }

  pub fn deinit(ctx: *Context) void {
    ctx.transport.deinit();
    ctx.out.deinit(ctx.allocator);
    ctx.in.deinit(ctx.allocator);
    ctx.handlers.deinit(ctx.allocator);
  }

  pub fn reset(ctx: *Context) !void {
    try ctx.queue(.{.command = .{.reset = HCI.Command.ControllerAndBaseband.Reset.init()}});
  }

  /// register a handler to be called when packets arrive
  pub fn attach(ctx: *Context, handler: Handler) !void {
    try ctx.handlers.append(ctx.allocator, handler);
  }

  /// Receive a single packet
  /// buffer it internally
  pub fn run(ctx: *Context) !void {
    for(ctx.out.items) |packet| {
      var payload = try ctx.transport.write(ctx.allocator, packet);
      defer ctx.allocator.free(payload);
      for(ctx.handlers.items) |handle| {
        if(handle.outHandler) |outHandler| outHandler(handle.ptr, ctx, &payload);
      }
    }
    
    // drain the out buffer
    while(ctx.out.popOrNull()) |_|{
      const packet = try ctx.transport.receive();
      try ctx.in.append(ctx.allocator, packet);
    }

    const packet = try ctx.transport.receive();
    try ctx.in.append(ctx.allocator, packet);
  }

  /// iterates over the buffer of packets and
  /// dispatches them to the callback handles
  /// TODO: filter by type
  pub fn runForHandlers(ctx: *Context) void {
    while(ctx.in.popOrNull()) |packet| {
      for(ctx.handlers.items) |handle| {
        handle.callback(handle.ptr, ctx, &packet);
      }
    }
  }

  /// enqueue a packet for being sent out
  pub fn queue(ctx: *Context, packet: Packet) !void {
    // std.log.debug("queue: {any}", .{packet});
    try ctx.out.append(ctx.allocator, packet);
  }
};

test {
  std.testing.refAllDecls(AssignedNumbers);
  std.testing.refAllDecls(HCI);
  std.testing.refAllDecls(AdvertisingData);
  // std.testing.refAllDecls(GAP);
  std.testing.refAllDecls(ATT);
}