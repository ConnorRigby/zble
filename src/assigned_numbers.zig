const std = @import("std");

/// Section 1 of the Assigned Numbers specification
pub const CommonDataType = enum(u8) {
  Flags                              = 0x01,
  IncompleteListOf16BitServiceUUIDs  = 0x02,
  CompleteListOf16BitServiceUUIDs    = 0x03,
  IncompleteListOf32BitServiceUUIDs  = 0x04,
  CompleteListOf32BitServiceUUIDs    = 0x05,
  IncompleteListOf128BitServiceUUIDs = 0x06,
  CompleteListOf128BitServiceUUIDs   = 0x07,
  ShortenedLocalName                 = 0x08,
  CompleteLocalName                  = 0x09,
  TXPowerLevel                       = 0x0A,
  ClassOfDevice                      = 0x0D,
  SimplePairingHashC192              = 0x0E,
  SimplePairingRandomizer            = 0x0F,
  DeviceID                           = 0x10,
  // SecurityManagerTKValue             = 0x10 // ???????
  SecurityManagerOutOfBandFlags      = 0x11,
  PeripheralConnectionIntervalRange  = 0x12,
  ListOf16BitServiceSolicitationUUIDs  = 0x14,
  ListOf128BitServiceSolicitationUUIDs = 0x15,
  ServiceData16BitUUID               = 0x16,
  PublicTargetAddress                = 0x17,
  RandomTargetAddress                = 0x18,
  Appearance                         = 0x19,
  AdvertisingInterval                = 0x1A,
  LEBluetoothDeviceAddress           = 0x1B,
  LERole                             = 0x1C,
  SimplePairingHashC256              = 0x1D,
  SimplePairingRandomizerR256        = 0x1E,
  ListOf32BitServiceSolicitationUUIDs = 0x1F,
  ServiceData32BitUUID               = 0x20,
  ServiceData128BitUUID              = 0x21,
  LESecureConnectionsConfirmation    = 0x22,
  LEConnectionsRandomValue           = 0x23,
  URI                                = 0x24,
  IndoorPositioning                  = 0x25,
  TransportDiscoveryData             = 0x26,
  LESupportedFeatures                = 0x27,
  ChannelMapUpdateIndication         = 0x28,
  PBADV                              = 0x29,
  MeshMessage                        = 0x2A,
  MeshBeacon                         = 0x2B,
  BIGInfo                            = 0x2C,
  BroadcastCode                      = 0x2D,
  ResolvableSetIdentifier            = 0x2E,
  AdvertisingDataInterval            = 0x2F,
  BraodcastName                      = 0x30,
  @"3DInformationData"               = 0x3D,
  ManufacturerSpecificData           = 0xFF
};

pub const Flags = packed union {
  named: packed struct {
    le_limited_discoverable_mode: u1,
    le_general_discoverable_mode: u1,
    br_edr_not_supported:         u1,
    le_br_edr_supported:          u1,
    _unused:                      u4
  },
  data: u8
};

test {
  const flags: Flags = .{.named = .{
    .le_limited_discoverable_mode = 0,
    .le_general_discoverable_mode = 1,
    .br_edr_not_supported         = 1,
    .le_br_edr_supported          = 0,
    ._unused                      = 0 
  }};
  try std.testing.expect(@intCast(u8, flags.data) == @as(u8, 0b00000110));
}
