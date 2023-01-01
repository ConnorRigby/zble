const std = @import("std");

test {
  var arr = try std.BoundedArray(u8, 5).init(0);
  try arr.insert(0, 'a');
  try arr.insert(0, 'b');
  try arr.insert(0, 'c');
  std.debug.print("\n", .{});
  while(arr.popOrNull()) |value| {
    std.log.err("{c}", .{value});
  }
}