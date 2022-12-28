// Host Interface implementation for HCI
const Transport = @import("transport.zig").Transport;

pub const Host = struct {
  transport: Transport,

  pub fn init() !Host {
    var transport = Transport.init();
    return .{ .transport = transport };
  }

  pub fn deinit(self: *Host) void {
    _ = self;
  }

  pub fn set_bd_addr(self: *Host) void {
    _ = self;
  }

  pub fn register_event_handler(self: *Host) void {
    _ = self;
  }

  pub fn remove_event_handler(self: *Host) void {
    _ = self;
  }

  pub fn register_acl_packet_handler(self: *Host) void {
    _ = self;
  }

  pub fn remove_acl_packet_handler(self: *Host) void {
    _ = self;
  }

  pub fn send_command(self: *Host) void {
    _ = self;
  }

};