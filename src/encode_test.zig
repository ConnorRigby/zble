const std = @import("std");
// Group Code
pub const OGF: u6  = 0x3; //000011
// Command Code
pub const OCF: u10 = 0x14; //0000001110
// Opcode
pub const OPC: u16 = 0x140C; //0000_1110_0000_1100

test {  
  var aaa = try std.testing.allocator.alloc(u8, 3);
  defer std.testing.allocator.free(aaa);
  aaa[0] = OCF;
  aaa[1] = OGF << 2;
  aaa[2] = 0;

  var expected = [_]u8{0x14,0x0c,0x0};
  try std.testing.expectEqualSlices(u8, aaa, &expected);
  
}
