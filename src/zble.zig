/// ZBLE - Bluetooth Low Energy in Zig
/// Files referenced from this module
/// should be expected to remain relatively
/// stable, tho the APIs may change.
/// This file is the "root" of the library
/// and everything referenced within will
/// be part of the core API. See each root file
/// For additional doocumentation

const std = @import("std");

/// Public HCI encoder/decoder interface
pub const HCI = @import("hci.zig");

/// Assigned numbers as described in the official
/// specification
pub const AssignedNumbers = @import("assigned_numbers.zig");

/// Helper for assembling data for the SetAdvertisingData command
pub const AdvertisingData = @import("advertising_data.zig");

/// Generic Attribute Table server implementation
pub const GATT = @import("gatt.zig");

test {
  std.testing.refAllDecls(HCI);
  std.testing.refAllDecls(AdvertisingData);
  std.testing.refAllDecls(GATT);
}