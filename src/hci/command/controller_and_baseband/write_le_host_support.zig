const std = @import("std");

/// The HCI_Write_LE_Host_Support command is used to set the LE Supported (Host)
/// and Simultaneous LE and BR/EDR to Same Device Capable (Host) Link Manager
/// Protocol feature bits.
/// 
/// * OGF: `0x3`
/// * OCF: `0x6D`
/// * Opcode: `0x6D0C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.79
/// 
/// ## Command Parameters
/// * `le_supported_host_enabled` - boolean (default: false)
/// 
/// Note that this command also carries the Simultaneous_LE_Host parameter.
/// However, this parameter is not exposed in this API because it is always false.
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteLEHostSupport = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x6D;
// Opcode
pub const OPC: u16 = 0x6D0C;

// fields: 
le_supported_host_enabled: bool,
unused: u8,

// payload length
length: usize,

pub fn init() WriteLEHostSupport {
  return .{
    .length = 5,
    .unused = 0,
    .le_supported_host_enabled = false
  };
}

// encode from a struct
pub fn encode(self: WriteLEHostSupport, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 2;
  command[3] = @boolToInt(self.le_supported_host_enabled);
  command[4] = self.unused;
  return command;
}

test "WriteLEHostSupport encode" {
  const write_le_host_support = WriteLEHostSupport.init();
  const encoded = try WriteLEHostSupport.encode(write_le_host_support, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(encoded[2] == 2);
}
