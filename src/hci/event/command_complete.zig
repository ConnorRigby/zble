const std = @import("std");
const HCI = @import("../../hci.zig");

/// > The Command Complete event is used by the Controller for most commands to
/// > transmit return status of a command and the other event parameters that are
/// > specified for the issued HCI command.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.14
pub const CommandComplete = @This();

pub const Code = 0xE;

pub const ErrorCode = enum(u8) {
  ok = 0x00,
  unknown_hci_command = 0x01,
  unknown_connection_id = 0x02,
  hardware_failure = 0x03,
  page_timeout = 0x04,
  auth_failure = 0x05,
  pin_or_key_missing = 0x06,
  memory_capacity_exceeded = 0x07,
  connection_timeout = 0x08,
  connection_limit_exceeded = 0x09,
  synchronous_connection_limit_to_a_device_exceeded = 0x0A,
  connection_already_exists = 0x0B,
  command_disallowed = 0x0C,
  connection_rejected_due_to_limited_resources = 0x0D,
  connection_rejected_due_to_security_reasons = 0x0E,
  connection_rejected_due_to_unacceptable_bd_addr = 0x0F,
  connection_accept_timeout_exceeded = 0x10,
  unsupported_feature_or_parameter_value = 0x11,
  invalid_hci_command_parameters = 0x12,
  remote_user_terminated_connection = 0x13,
  remote_device_terminated_connection_due_to_low_resources = 0x14,
  remote_device_terminated_connection_due_to_power_off = 0x15,
  connection_terminated_by_local_host = 0x16,
  repeated_attempts = 0x17,
  pairing_not_allowed = 0x18,
  unknown_lmp_pdu = 0x19,
  unsupported_remote_feature = 0x1A,
  sco_offset_rejected = 0x1B,
  sco_interval_rejected = 0x1C,
  sco_air_mode_rejected = 0x1D,
  invalid_lmp_parameters = 0x1E,
  unspecified_error = 0x1F,
  unsupported_lmp_parameter_value = 0x20,
  role_change_not_allowed = 0x21,
  lmp_response_timeout = 0x22,
  lmp_error_transaction_collision = 0x23,
  lmp_pdu_not_allowed = 0x24,
  encryption_mode_not_acceptable = 0x25,
  link_key_cannot_be_changed = 0x26,
  requested_qos_not_supported = 0x27,
  instant_passed = 0x28,
  pairing_with_unit_key_not_supported = 0x29,
  different_transaction_collision = 0x2A,
  reserved_0x2b = 0x2B,
  qos_unacceptable_parameter = 0x2C,
  qos_rejected = 0x2D,
  channel_classification_not_supported = 0x2E,
  insufficient_security = 0x2F,
  parameter_out_of_mandatory_range = 0x30,
  reserved_0x31 = 0x31,
  role_switch_pending = 0x32,
  reserved_0x33 = 0x33,
  reserved_slot_violation = 0x34,
  role_switch_failed = 0x35,
  extended_inquiry_response_too_large = 0x36,
  secure_simple_pairing_not_supported = 0x37,
  host_busy_pairing = 0x38,
  connection_rejected_no_suitable_channel = 0x39,
  controller_busy = 0x3A,
  unacceptable_connection_parameters = 0x3B,
  advertising_timeout = 0x3C,
  connection_terminated_due_to_mic_failure = 0x3D,
  connection_failed_to_be_established = 0x3E,
  mac_connection_failed = 0x3F,
  course_clock_adjustment_rejected = 0x40,
  type0_submap_not_defined = 0x41,
  unknown_advertising_identifier = 0x42,
  limit_reached = 0x43,
  operation_cancelled_by_host = 0x44,
  packet_too_long = 0x45,
};

pub const ErrorCodeReturnParameters = struct {
  error_code: ErrorCode,
  pub fn format(params: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    try writer.print("{s}", .{@tagName(params.error_code)});
  }
};

pub const ReturnParameters = union(HCI.Command.OPC) {
  set_event_mask: ErrorCodeReturnParameters,
  read_local_version: struct {
    error_code:         ErrorCode,
    hci_version:        u8,
    hci_revision:       u16,
    lmp_pal_version:    u8,
    manufacturer_name:  u16,
    lmp_pal_subversion: u16
  },
  read_buffer_size_v1: struct {
    error_code:                 ErrorCode,
    acl_data_packet_length:     u16,
    total_num_acl_data_packets: u8
  },
  reset:                                  ErrorCodeReturnParameters,
  le_set_random_address:                  ErrorCodeReturnParameters,
  le_set_advertising_parameters:          ErrorCodeReturnParameters,
  le_set_advertising_data:                ErrorCodeReturnParameters,
  le_set_advertising_enable:              ErrorCodeReturnParameters,
  le_set_scan_parameters:                 ErrorCodeReturnParameters,
  le_set_scan_enable:                     ErrorCodeReturnParameters,
  // create_connection:                      struct {}, // no return params
  le_create_connection_cancel:               ErrorCodeReturnParameters,
  write_default_link_policy_settings:     ErrorCodeReturnParameters,
  write_local_name:                       ErrorCodeReturnParameters,
  read_local_name:                        ErrorCodeReturnParameters,
  write_page_timeout:                     ErrorCodeReturnParameters,
  write_scan_enable:                      ErrorCodeReturnParameters,
  write_class_of_device:                  ErrorCodeReturnParameters,
  write_synchronous_flow_control_enable:  ErrorCodeReturnParameters,
  write_inquiry_mode:                     ErrorCodeReturnParameters,
  write_extended_inquiry_response:        ErrorCodeReturnParameters,
  write_simple_pairing_mode:              ErrorCodeReturnParameters,
  write_default_erroneous_data_reporting: ErrorCodeReturnParameters,
  write_le_host_support:                  ErrorCodeReturnParameters,
  write_secure_connections_host_support:  ErrorCodeReturnParameters,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    switch(value) {
      inline else => |data| {
        try writer.print("{s}{{{any}}}", .{@tagName(value), data});
      }
    }
  }
};

num_hci_command_packets: u8,
command_opcode: HCI.Command.OPC,
return_parameters: ReturnParameters