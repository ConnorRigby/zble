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
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = @sizeOf(@TypeOf(self.class));
  std.mem.writeInt(u24, command[3..6], self.class, .Little);
  return command;
}

test "WriteClassOfDevice encode" {
  const write_class_of_device = WriteClassOfDevice.init();
  const encoded = try WriteClassOfDevice.encode(write_class_of_device, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  const class = std.mem.readInt(u24, encoded[3..6], .Little);
  try std.testing.expect(class == write_class_of_device.class);
}
