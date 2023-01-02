const std = @import("std");

pub const ControllerAndBaseband   = @import("command/controller_and_baseband.zig");
pub const InformationalParameters = @import("command/informational_parameters.zig");
pub const LEController            = @import("command/le_controller.zig");
pub const LinkPolicy              = @import("command/link_policy.zig");

/// Opcode Group
pub const OGF = enum(u10) {
  controller_and_baseband  = ControllerAndBaseband.OGF,
  informational_parameters = InformationalParameters.OGF,
  le_controller            = LEController.OGF,
  link_policy              = LinkPolicy.OGF,
};

/// Opcode
pub const OPC = enum(u16) {
  set_event_mask                         = ControllerAndBaseband.SetEventMask.OPC,
  read_local_version                     = InformationalParameters.ReadLocalVersion.OPC,
  read_buffer_size_v1                    = LEController.ReadBufferSizeV1.OPC,
  reset                                  = ControllerAndBaseband.Reset.OPC,
  le_set_random_address                  = LEController.SetRandomAddress.OPC,
  le_set_advertising_parameters          = LEController.SetAdvertisingParameters.OPC,
  le_set_advertising_data                = LEController.SetAdvertisingData.OPC,
  le_set_advertising_enable              = LEController.SetAdvertisingEnable.OPC,
  le_set_scan_parameters                 = LEController.SetScanParameters.OPC,
  le_set_scan_enable                     = LEController.SetScanEnable.OPC,
  le_create_connection_cancel            = LEController.CreateConnectionCancel.OPC,
  write_default_link_policy_settings     = LinkPolicy.WriteDefaultLinkPolicySettings.OPC,
  write_local_name                       = ControllerAndBaseband.WriteLocalName.OPC,
  read_local_name                        = ControllerAndBaseband.ReadLocalName.OPC,
  write_page_timeout                     = ControllerAndBaseband.WritePageTimeout.OPC,
  write_scan_enable                      = ControllerAndBaseband.WriteScanEnable.OPC,
  write_class_of_device                  = ControllerAndBaseband.WriteClassOfDevice.OPC,
  write_synchronous_flow_control_enable  = ControllerAndBaseband.WriteSynchronousFlowControlEnable.OPC,
  write_inquiry_mode                     = ControllerAndBaseband.WriteInquiryMode.OPC,
  write_extended_inquiry_response        = ControllerAndBaseband.WriteExtendedInquiryResponse.OPC,
  write_simple_pairing_mode              = ControllerAndBaseband.WriteSimplePairingMode.OPC,
  write_default_erroneous_data_reporting = ControllerAndBaseband.WriteDefaultErroneousDataReporting.OPC,
  write_le_host_support                  = ControllerAndBaseband.WriteLEHostSupport.OPC,
  write_secure_connections_host_support  = ControllerAndBaseband.WriteSecureConnectionsHostSupport.OPC,
  _,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    try writer.print("{s}(0x{X:1})", .{@tagName(value), @enumToInt(value)});
  }
};

test {
  std.testing.refAllDecls(@This());
}
