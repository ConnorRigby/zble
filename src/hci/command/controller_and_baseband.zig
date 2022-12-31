const std = @import("std");

pub const OGF: u6 = 0x3;

pub const SetEventMask = @import("controller_and_baseband/set_event_mask.zig");
pub const Reset = @import("controller_and_baseband/reset.zig");
pub const WriteLocalName = @import("controller_and_baseband/write_local_name.zig");
pub const ReadLocalName = @import("controller_and_baseband/read_local_name.zig");
pub const WritePageTimeout = @import("controller_and_baseband/write_page_timeout.zig");
pub const WriteScanEnable = @import("controller_and_baseband/write_scan_enable.zig");
pub const WriteClassOfDevice = @import("controller_and_baseband/write_class_of_device.zig");
pub const WriteSynchronousFlowControlEnable = @import("controller_and_baseband/write_synchronous_flow_control_enable.zig");
pub const WriteInquiryMode = @import("controller_and_baseband/write_inquiry_mode.zig");
pub const WriteExtendedInquiryResponse = @import("controller_and_baseband/write_extended_inquiry_response.zig");
pub const WriteSimplePairingMode = @import("controller_and_baseband/write_simple_pairing_mode.zig");
pub const WriteDefaultErroneousDataReporting = @import("controller_and_baseband/write_default_erroneous_data_reporting.zig");
pub const WriteLEHostSupport = @import("controller_and_baseband/write_le_host_support.zig");
pub const WriteSecureConnectionsHostSupport = @import("controller_and_baseband/write_secure_connections_host_support.zig");

test {
  std.testing.refAllDecls(@This());
}
