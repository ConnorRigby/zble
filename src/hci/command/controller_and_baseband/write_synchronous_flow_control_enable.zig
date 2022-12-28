const std = @import("std");

/// This command provides the ability to write the Synchronous_Flow_Control_Enable
/// parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x2F`
/// * Opcode: `"/\f"`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.37
/// 
/// The Synchronous_Flow_Control_Enable configuration parameter allows the Host to
/// decide if the BR/EDR Controller will send HCI_Number_Of_Completed_Packets
/// events for synchronous Connection_Handles. This setting allows the Host to
/// enable and disable synchronous flow control.
/// 
/// The Synchronous_Flow_Control_Enable parameter can only be changed if no
/// connections exist.
/// 
/// ## Command Parameters
/// * `enabled` - boolean (default: false)
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteSynchronousFlowControlEnable = @This();

// Group Code
pub const OGF: u8  = 0xC;
// Command Code
pub const OCF: u10 = 0x2F;
// Opcode
pub const OPC: u16 = 0xC2F;

// fields: 
// * enabled

// encode from a struct
pub fn encode(self: WriteSynchronousFlowControlEnable) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteSynchronousFlowControlEnable {
  _ = payload;
  return .{};
}

test "WriteSynchronousFlowControlEnable decode" {
  const payload = [_]u8 {};
  const decoded = WriteSynchronousFlowControlEnable.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteSynchronousFlowControlEnable encode" {
  const write_synchronous_flow_control_enable = .{};
  const encoded = WriteSynchronousFlowControlEnable.encode(write_synchronous_flow_control_enable);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
