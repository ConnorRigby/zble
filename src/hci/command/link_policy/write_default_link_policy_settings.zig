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
pub const OGF: u8  = 0x8;
// Command Code
pub const OCF: u10 = 0xF;
// Opcode
pub const OPC: u16 = 0x80F;

// fields: 
// * enable_hold_mode
// * enable_role_switch
// * enable_sniff_mode

// encode from a struct
pub fn encode(self: WriteDefaultLinkPolicySettings) []u8 {
  _ = self;
  return &[_]u8{};
}

// decode from a binary
pub fn decode(payload: []u8) WriteDefaultLinkPolicySettings {
  _ = payload;
  return .{};
}

test "WriteDefaultLinkPolicySettings decode" {
  const payload = [_]u8 {};
  const decoded = WriteDefaultLinkPolicySettings.decode(&payload);
  _ = decoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}

test "WriteDefaultLinkPolicySettings encode" {
  const write_default_link_policy_settings = .{};
  const encoded = WriteDefaultLinkPolicySettings.encode(write_default_link_policy_settings);
  _ = encoded;
  try std.testing.expect(false);
  @panic("test not implemented yet");
}
