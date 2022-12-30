const std = @import("std");

/// This command writes the Secure_Connections_Host_Support parameter in the BR/EDR Controller.
/// 
/// * OGF: `0x3`
/// * OCF: `0x7A`
/// * Opcode: `0x7A0C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.92
/// 
/// When Secure Connections Host Support is set to 'enabled' the Controller shall
/// use the enhanced reporting mechanisms for the Encryption_Enabled parameter in
/// the HCI_Encryption_Change event (see Section 7.7.8) and the Key_Type parameter
/// in the HCI_Link_Key_Notification event (see Section 7.7.24). If the Host
/// issues this command while the Controller is paging, has page scanning enabled,
/// or has an ACL connection, the Controller shall return the error code Command
/// Disallowed (0x0C).
/// 
/// The Link Manager Secure Connections (Host Support) feature bit shall be set to
/// the Secure_Connections_Host_Support parameter. The default value for
/// Secure_Connections_Host_Support shall be 'disabled.' When
/// Secure_Connections_Host_Support is set to 'enabled,' the bit in the LMP
/// features mask indicating support for Secure Connections (Host Support) shall
/// be set to enabled in subsequent responses to an LMP_FEATURES_REQ from a remote
/// device.
/// 
/// ## Command Parameters
/// * `enabled` - boolean
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteSecureConnectionsHostSupport = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x7A;
// Opcode
pub const OPC: u16 = 0x7A0C;

// fields: 
enabled: bool,

// payload length
length: usize,
pub fn init() WriteSecureConnectionsHostSupport {
  return .{
    .length = 4,
    .enabled = false
  };
}

// encode from a struct
pub fn encode(self: WriteSecureConnectionsHostSupport, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 1;
  command[3] = @boolToInt(self.enabled);
  // TODO: implement encoding WriteSecureConnectionsHostSupport

  return command;
}

test "WriteSecureConnectionsHostSupport encode" {
  const write_secure_connections_host_support = WriteSecureConnectionsHostSupport.init();
  const encoded = try WriteSecureConnectionsHostSupport.encode(write_secure_connections_host_support, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
