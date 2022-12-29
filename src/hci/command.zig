const std = @import("std");

pub const SetEventMask = @import("command/controller_and_baseband/set_event_mask.zig");
pub const ReadLocalVersion = @import("command/informational_parameters/read_local_version.zig");
pub const ReadBufferSizeV1 = @import("command/le_controller/read_buffer_size_v1.zig");
pub const Reset = @import("command/controller_and_baseband/reset.zig");
pub const SetRandomAddress = @import("command/le_controller/set_random_address.zig");
pub const SetAdvertisingParameters = @import("command/le_controller/set_advertising_parameters.zig");
pub const SetAdvertisingData = @import("command/le_controller/set_advertising_data.zig");
pub const SetAdvertisingEnable = @import("command/le_controller/set_advertising_enable.zig");
pub const SetScanParameters = @import("command/le_controller/set_scan_parameters.zig");
pub const SetScanEnable = @import("command/le_controller/set_scan_enable.zig");
pub const CreateConnection = @import("command/le_controller/create_connection.zig");
pub const CreateConnectionCancel = @import("command/le_controller/create_connection_cancel.zig");
pub const ReadWhiteListSize = @import("command/le_controller/read_white_list_size.zig");
pub const WriteDefaultLinkPolicySettings = @import("command/link_policy/write_default_link_policy_settings.zig");
pub const WriteLocalName = @import("command/controller_and_baseband/write_local_name.zig");
pub const ReadLocalName = @import("command/controller_and_baseband/read_local_name.zig");
pub const WritePageTimeout = @import("command/controller_and_baseband/write_page_timeout.zig");
pub const WriteScanEnable = @import("command/controller_and_baseband/write_scan_enable.zig");
pub const WriteClassOfDevice = @import("command/controller_and_baseband/write_class_of_device.zig");
pub const WriteSynchronousFlowControlEnable = @import("command/controller_and_baseband/write_synchronous_flow_control_enable.zig");
pub const WriteInquiryMode = @import("command/controller_and_baseband/write_inquiry_mode.zig");
pub const WriteExtendedInquiryResponse = @import("command/controller_and_baseband/write_extended_inquiry_response.zig");
pub const WriteSimplePairingMode = @import("command/controller_and_baseband/write_simple_pairing_mode.zig");
pub const WriteDefaultErroneousDataReporting = @import("command/controller_and_baseband/write_default_erroneous_data_reporting.zig");
pub const WriteLEHostSupport = @import("command/controller_and_baseband/write_le_host_support.zig");
pub const WriteSecureConnectionsHostSupport = @import("command/controller_and_baseband/write_secure_connections_host_support.zig");


pub const ControllerAndBaseband = @import("command/controller_and_baseband.zig");
pub const InformationalParameters = @import("command/informational_parameters.zig");
pub const LEController = @import("command/le_controller.zig");
pub const LinkPolicy = @import("command/link_policy.zig");

pub const Command = @This();

/// Opcode Group
pub const OGF = enum(u10) {
  controller_and_baseband = 0x3,
  informational_parameters = 0x4,
  le_controller = 0x8,
  link_policy = 0x2,

};

/// Opcode
pub const OPC = enum(u16) {
  set_event_mask = 0x10C,
  read_local_version = 0x110,
  read_buffer_size_v1 = 0x220,
  reset = 0x30C,
  set_random_address = 0x520,
  set_advertising_parameters = 0x620,
  set_advertising_data = 0x820,
  set_advertising_enable = 0xA20,
  set_scan_parameters = 0xB20,
  set_scan_enable = 0xC20,
  create_connection = 0xD20,
  create_connection_cancel = 0xE20,
  read_white_list_size = 0xF20,
  write_default_link_policy_settings = 0xF08,
  write_local_name = 0x130C,
  read_local_name = 0x140C,
  write_page_timeout = 0x180C,
  write_scan_enable = 0x1A0C,
  write_class_of_device = 0x240C,
  write_synchronous_flow_control_enable = 0x2F0C,
  write_inquiry_mode = 0x450C,
  write_extended_inquiry_response = 0x520C,
  write_simple_pairing_mode = 0x560C,
  write_default_erroneous_data_reporting = 0x5B0C,
  write_le_host_support = 0x6D0C,
  write_secure_connections_host_support = 0x7A0C,

};

pub const Header = union(OGF) {
  controller_and_baseband: ControllerAndBaseband,
  informational_parameters: InformationalParameters,
  le_controller: LEController,
  link_policy: LinkPolicy,

};
pub const Payload = union(OPC) {
  set_event_mask: SetEventMask,
  read_local_version: ReadLocalVersion,
  read_buffer_size_v1: ReadBufferSizeV1,
  reset: Reset,
  set_random_address: SetRandomAddress,
  set_advertising_parameters: SetAdvertisingParameters,
  set_advertising_data: SetAdvertisingData,
  set_advertising_enable: SetAdvertisingEnable,
  set_scan_parameters: SetScanParameters,
  set_scan_enable: SetScanEnable,
  create_connection: CreateConnection,
  create_connection_cancel: CreateConnectionCancel,
  read_white_list_size: ReadWhiteListSize,
  write_default_link_policy_settings: WriteDefaultLinkPolicySettings,
  write_local_name: WriteLocalName,
  read_local_name: ReadLocalName,
  write_page_timeout: WritePageTimeout,
  write_scan_enable: WriteScanEnable,
  write_class_of_device: WriteClassOfDevice,
  write_synchronous_flow_control_enable: WriteSynchronousFlowControlEnable,
  write_inquiry_mode: WriteInquiryMode,
  write_extended_inquiry_response: WriteExtendedInquiryResponse,
  write_simple_pairing_mode: WriteSimplePairingMode,
  write_default_erroneous_data_reporting: WriteDefaultErroneousDataReporting,
  write_le_host_support: WriteLEHostSupport,
  write_secure_connections_host_support: WriteSecureConnectionsHostSupport,

};

header: Header,
payload: Payload,

test {
  std.testing.refAllDecls(Command);
}

test {
  try std.testing.expect(false);
}
