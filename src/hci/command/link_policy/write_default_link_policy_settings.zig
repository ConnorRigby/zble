const std = @import("std");

/// This command writes the Default Link Policy configuration value.
/// 
/// Bluetooth Core Version 5.2 | Vol 4, Part E, section 7.2.12
/// 
/// The Default_Link_Policy_Settings parameter determines the initial value of the Link_Policy_Settings for all new BR/EDR connections.
/// 
/// Note: See the Link Policy Settings configuration parameter for more information. See Section 6.18.
/// 
/// * OGF: `0x2`
/// * OCF: `0xF`
/// * Opcode: `<<15, 8>>`
pub const WriteDefaultLinkPolicySettings = @This();

// Group Code
pub const OGF: u6  = 0x2;
// Command Code
pub const OCF: u10 = 0xF;
// Opcode
pub const OPC: u16 = 0xF08;

// fields: 
// * enable_hold_mode
// * enable_role_switch
// * enable_sniff_mode

// payload length
length: usize,
pub fn init() WriteDefaultLinkPolicySettings {
  return .{.length = 3};
}

// encode from a struct
pub fn encode(self: WriteDefaultLinkPolicySettings, allocator: std.mem.Allocator) ![]u8 {
  var command = try allocator.alloc(u8, self.length);
  errdefer allocator.free(command);
  std.mem.writeInt(u16, command[0..2], OPC, .Big);
  command[2] = 0;
  // TODO: implement encoding WriteDefaultLinkPolicySettings

  return command;
}

// decode from a binary
pub fn decode(payload: []u8) WriteDefaultLinkPolicySettings {
  std.debug.assert(payload[0] == OCF);
  std.debug.assert(payload[1] == OGF >> 2);
  return .{.length = payload.len};
}

test "WriteDefaultLinkPolicySettings decode" {
  var payload = [_]u8 {OCF, OGF >> 2, 0};
  const decoded = WriteDefaultLinkPolicySettings.decode(&payload);
  _ = decoded;
  std.log.warn("unimplemented", .{});
}

test "WriteDefaultLinkPolicySettings encode" {
  const write_default_link_policy_settings = WriteDefaultLinkPolicySettings.init();
  const encoded = try WriteDefaultLinkPolicySettings.encode(write_default_link_policy_settings, std.testing.allocator);
  defer std.testing.allocator.free(encoded);
  try std.testing.expect(encoded[0] == OCF);
  try std.testing.expect(encoded[1] == OGF << 2);
  std.log.warn("unimplemented", .{});
}
