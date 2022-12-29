const std = @import("std");

/// The HCI_Write_LE_Host_Support command is used to set the LE Supported (Host)
/// and Simultaneous LE and BR/EDR to Same Device Capable (Host) Link Manager
/// Protocol feature bits.
/// 
/// * OGF: `0x3`
/// * OCF: `0x6D`
/// * Opcode: `"m\f"`
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

// payload length
length: usize,
// fields: 

le_supported_host_enabled: u8,
pub fn init() WriteLEHostSupport {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: WriteLEHostSupport, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = self.le_supported_host_enabled;
  // TODO: implement encoding WriteLEHostSupport

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteLEHostSupport {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  
  return .{.length = payload.len, .le_supported_host_enabled = payload[2] };
}

test "WriteLEHostSupport decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteLEHostSupport.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteLEHostSupport encode" {
  const write_le_host_support = .{.length = 3};
  const encoded = try WriteLEHostSupport.encode(write_le_host_support, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF >> 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
