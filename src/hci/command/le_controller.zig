const std = @import("std");

pub const OGF: u6 = 0x8;

pub const ReadBufferSizeV1 = @import("le_controller/read_buffer_size_v1.zig");
pub const SetRandomAddress = @import("le_controller/set_random_address.zig");
pub const SetAdvertisingParameters = @import("le_controller/set_advertising_parameters.zig");
pub const SetAdvertisingData = @import("le_controller/set_advertising_data.zig");
pub const SetAdvertisingEnable = @import("le_controller/set_advertising_enable.zig");
pub const SetScanParameters = @import("le_controller/set_scan_parameters.zig");
pub const SetScanEnable = @import("le_controller/set_scan_enable.zig");
// pub const CreateConnection = @import("le_controller/create_connection.zig");
pub const CreateConnectionCancel = @import("le_controller/create_connection_cancel.zig");


test {
  std.testing.refAllDecls(@This());
}
