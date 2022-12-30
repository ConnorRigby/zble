const std = @import("std");

/// This command writes the value for the Class_Of_Device parameter.
/// 
/// * OGF: `0x3`
/// * OCF: `0x24`
/// * Opcode: `0x240C`
/// 
/// Bluetooth Spec v5.2, Vol 4, Part E, section 7.3.26
/// 
/// ## Command Parameters
/// * `class` - integer for class of devic
/// 
/// ## Return Parameters
/// * `:status` - command status code
pub const WriteClassOfDevice = @This();

// Group Code
pub const OGF: u6  = 0x3;
// Command Code
pub const OCF: u10 = 0x24;
// Opcode
pub const OPC: u16 = 0x240C;

// fields: 
class: u24,

// payload length
length: usize,
pub fn init() WriteClassOfDevice {
  return .{
    .length = 6,
    .class = 0x000
  };
}

// encode from a struct
pub fn encode(self: WriteClassOfDevice, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  command[0] = OCF;
  command[1] = OGF << 2;
  command[2] = 3;
  command[3] = @intCast(u8, self.class >> 16);
  command[4] = @intCast(u8, self.class >> 8);
  command[5] = @intCast(u8, self.class);
  // TODO: implement encoding WriteClassOfDevice

  return command;
}

test "WriteClassOfDevice encode" {
  const write_class_of_device = WriteClassOfDevice.init();
  const encoded = try WriteClassOfDevice.encode(write_class_of_device, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
