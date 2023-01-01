const std = @import("std");

const AssignedNumbers = @import("assigned_numbers.zig");
const CommonDataType = AssignedNumbers.CommonDataType;
const AdvertisingData = @This();

/// comptime Structure that can be used to populated the
/// the AdvertisingData value of SetAdvertisingData struct
pub fn Field(
  comptime common_data_type: CommonDataType,
  comptime value: anytype // []u8
) AdvertisingData {
  if(@sizeOf(@TypeOf(value)) > 31) @panic("Size must be less than 31 octets");

  return .{
    .length = value.len,
    .data_type = common_data_type,
    .data = value
  };
}

length: u8,
data_type: CommonDataType,
data: []const u8,

pub fn encodeOne(field: *const AdvertisingData, allocator: std.mem.Allocator) ![]u8 {
  // [length][type][data(length-1)]
  var encoded = try allocator.alloc(u8, field.length + 2);
  errdefer allocator.free(encoded);
  std.mem.set(u8, encoded, 0);

  encoded[0] = field.length + 1;
  encoded[1] = @enumToInt(field.data_type);
  std.mem.copy(u8, encoded[2..], field.data);
  return encoded;
}

/// Assemble an array of AdvertisingData structs into a byte array
pub fn encodeAll(fields: []const *const AdvertisingData, allocator: std.mem.Allocator) ![31]u8 {
  // final encoded value
  var advertising_data = try std.BoundedArray(u8, 31).init(0);
  std.mem.set(u8, &advertising_data.buffer, 0);
  var index:u5 = 0; // 0b11111
  for(fields) |field| {
    var field_data = try encodeOne(field, allocator);
    defer allocator.free(field_data);
    var start = index;
    var end = start + @truncate(u5, field_data.len);
    std.mem.copy(u8, advertising_data.buffer[start..end], field_data);
    index = index + @truncate(u5, field_data.len); // index = end;
  }

  return advertising_data.buffer;
}

test "manual memory management" {
  const flags = Field(.Flags, &[1]u8{0b00000110});
  try std.testing.expect(flags.data[0] == 0b00000110);

  const complete_local_name = Field(.CompleteLocalName, "zBLE");
  try std.testing.expectFmt("zBLE", "{s}", .{complete_local_name.data});

  const flags_data = try flags.encodeOne(std.testing.allocator);
  defer std.testing.allocator.free(flags_data);

  try std.testing.expect(flags_data[0] == 2); // length
  try std.testing.expect(flags_data[1] == @enumToInt(flags.data_type));
  try std.testing.expect(flags_data[2] == 0b00000110);
  try std.testing.expect(flags_data.len == 3);

  const complete_local_name_data = try complete_local_name.encodeOne(std.testing.allocator);
  defer std.testing.allocator.free(complete_local_name_data);

  try std.testing.expect(complete_local_name_data[0] == 5); // length
  try std.testing.expect(complete_local_name_data[1] == @enumToInt(complete_local_name.data_type));
  try std.testing.expect(complete_local_name_data[2] == 'z');
  try std.testing.expect(complete_local_name_data[3] == 'B');
  try std.testing.expect(complete_local_name_data[4] == 'L');
  try std.testing.expect(complete_local_name_data[5] == 'E');
  try std.testing.expect(complete_local_name_data.len == 6);

  var advertising_data = try std.testing.allocator.alloc(u8, 
    flags_data.len + complete_local_name_data.len
  );
  defer std.testing.allocator.free(advertising_data);
  std.mem.set(u8, advertising_data, 0);
  try std.testing.expect(advertising_data.len == 9);

  std.mem.copy(u8, advertising_data[0..flags_data.len], flags_data);
  std.mem.copy(u8, advertising_data[flags_data.len..flags_data.len+complete_local_name_data.len], complete_local_name_data);

  try std.testing.expect(advertising_data[0] == 2);
  try std.testing.expect(advertising_data[1] == @enumToInt(flags.data_type));
  try std.testing.expect(advertising_data[2] == 0b00000110);
  try std.testing.expect(advertising_data[3] == 5); // length
  try std.testing.expect(advertising_data[4] == @enumToInt(complete_local_name.data_type));
  try std.testing.expect(advertising_data[5] == 'z');
  try std.testing.expect(advertising_data[6] == 'B');
  try std.testing.expect(advertising_data[7] == 'L');
  try std.testing.expect(advertising_data[8] == 'E');
}

test "encodeAll" {
  // 1 byte
  const flags = Field(.Flags, &[1]u8{0b00000110});
  try std.testing.expect(flags.data[0] == 0b00000110);

  // 4 bytes
  const complete_local_name = Field(.CompleteLocalName, "zBLE");
  try std.testing.expectFmt("zBLE", "{s}", .{complete_local_name.data});

  // constant array of pointers
  const advertising_data_arr = [_]*const AdvertisingData{&flags, &complete_local_name};
  
  // 9 bytes allocated on the heap
  const advertising_data = try encodeAll(&advertising_data_arr, std.testing.allocator);

  try std.testing.expect(advertising_data[0] == 2);
  try std.testing.expect(advertising_data[1] == @enumToInt(flags.data_type));
  try std.testing.expect(advertising_data[2] == 0b00000110);
  try std.testing.expect(advertising_data[3] == 5); // length
  try std.testing.expect(advertising_data[4] == @enumToInt(complete_local_name.data_type));
  try std.testing.expect(advertising_data[5] == 'z');
  try std.testing.expect(advertising_data[6] == 'B');
  try std.testing.expect(advertising_data[7] == 'L');
  try std.testing.expect(advertising_data[8] == 'E');
}