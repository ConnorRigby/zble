const std = @import("std");

const AssignedNumbers = @import("assigned_numbers.zig");
const CommonDataType = AssignedNumbers.CommonDataType;

/// comptime Structure that can be used to populated the
/// the AdvertisingData value of SetAdvertisingData struct
pub fn AdvertisingDataField(
  comptime common_data_type: CommonDataType,
  comptime value: anytype // []u8
) type {
  if(@sizeOf(@TypeOf(value)) > 31) @panic("Size must be less than 31 octets");

  return struct {
    const Self     = @This();
    const DataType = common_data_type;
    const Length   = value.len;

    data: @TypeOf(value),

    pub fn init() Self {
      return .{.data = value};
    }

    pub fn encode(field: Self, allocator: std.mem.Allocator) ![]u8 {
      var encoded = try allocator.alloc(u8, Length + 1);
      errdefer allocator.free(encoded);
      std.mem.set(u8, encoded, 0);

      encoded[0] = Length;
      const to_copy = @ptrCast(*const[Length]u8, field.data);
      std.mem.copy(u8, encoded[1..], to_copy);
      return encoded;
    }
  };
}

test {
  const Data = AdvertisingDataField(.CompleteLocalName, "zBLE");
  const field = Data.init();
  const binary = try field.encode(std.testing.allocator);
  defer std.testing.allocator.free(binary);

  try std.testing.expectFmt("zBLE", "{s}", .{field.data});
  try std.testing.expect(binary[0] == 4); // length
  try std.testing.expect(binary[1] == 'z');
  try std.testing.expect(binary[2] == 'B');
  try std.testing.expect(binary[3] == 'L');
  try std.testing.expect(binary[4] == 'E');
}