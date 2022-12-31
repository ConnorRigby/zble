pub const Server = @This();

const HCI = @import("../hci.zig");

pub const SetAdvertisingParameters = HCI.Command.SetAdvertisingParameters;
pub const SetAdvertisingData = HCI.Command.SetAdvertisingData;

pub const State = enum() {
  Wait,
  Advertise,
  Connect
};

state: State,
transport: HCI.Transport.Uart,

pub fn set_advertising_parameters(self: *Server, set_advertising_parameters: SetAdvertisingParameters) !void {
  try self.transport.write_packet(.{.command = .{set_advertising_parameters = set_advertising_parameters}});
}

pub fn set_advertising_data(self: *Server, sete_advertising_data: SetAdvertisingData) !void {
  try self.transport.write_packet(.{.command = .{sete_advertising_data = sete_advertising_data}});
}

// pub fn start_advertising(self: *Server) 

// pub fn stop_advertising(self: *Server)

pub fn handle_packet(self: *Server, packet: HCI.Packet) void {

}