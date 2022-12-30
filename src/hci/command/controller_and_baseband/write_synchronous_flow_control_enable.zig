const std = @import("std");

/// This command provides the ability to write the Synchronous_Flow_Control_Enable
/// parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x2F`
/// * Opcode: `0x2F0C`
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
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x2F;
// Opcode
pub const OPC: u16 = 0x2F0C;

// fields: 
enabled: bool,

// payload length
length: usize,
pub fn init() WriteSynchronousFlowControlEnable {
  return .{
    .length = 4,
    .enabled = false
  };
}

// encode from a struct
pub fn encode(self: WriteSynchronousFlowControlEnable, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 1;
  command[3] = @boolToInt(self.enabled);
  // TODO: implement encoding WriteSynchronousFlowControlEnable

  return command;
}

test "WriteSynchronousFlowControlEnable encode" {
  const write_synchronous_flow_control_enable = WriteSynchronousFlowControlEnable.init();
  const encoded = try WriteSynchronousFlowControlEnable.encode(write_synchronous_flow_control_enable, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
