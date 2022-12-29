const std = @import("std");

/// The HCI_Write_Local_Name command provides the ability to modify the user- friendly name for the BR/EDR Controller.
/// 
/// * OGF: `0x3`
/// * OCF: `0x13`
/// * Opcode: `0x130C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.11
/// 
/// ## Command Parameters
/// * `name` - A UTF-8 encoded User-Friendly Descriptive Name for the device. Up-to 248 bytes
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteLocalName = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x13;
// Opcode
pub const OPC: u16 = 0x130C;

// fields: 
name: [248]u8,

// payload length
length: usize,
pub fn init() WriteLocalName {
  return .{
    .length = 251,
    .name = [_]u8{'z', 'B', 'l', 'e'} ++ std.mem.zeroes([244]u8)
  };
}

// encode from a struct
pub fn encode(self: WriteLocalName, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 248;
  std.mem.copy(u8, command[3..], &self.name);

  // TODO: implement encoding WriteLocalName

  return command;
}

test "WriteLocalName encode" {
  const write_local_name = WriteLocalName.init();
  const encoded = try WriteLocalName.encode(write_local_name, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
