const std = @import("std");

/// A struct representing a LE Advertising Report.
/// 
/// > The LE Advertising Report event indicates that one or more Bluetooth devices have responded to
/// > an active scan or have broadcast advertisements that were received during a passive scan. The
/// > Controller may queue these advertising reports and send information from multiple devices in
/// > one LE Advertising Report event.
/// >
/// > This event shall only be generated if scanning was enabled using the LE Set Scan Enable
/// > command. It only reports advertising events that used legacy advertising PDUs.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.65.2
pub const AdvertisingReport = @This();

pub const Code = 0x3E;

test "AdvertisingReport decode " {
  //TODO: implement test
  std.log.warn("unimplemented", .{});}
