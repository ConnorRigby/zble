const std = @import("std");

/// The HCI_LE_Connection_Complete event indicates to both of the Hosts forming
/// the connection that a new connection has been created.
/// 
/// Upon the creation of the connection a Connection_Handle shall be assigned by
/// the Controller, and passed to the Host in this event. If the connection
/// creation fails this event shall be provided to the Host that had issued the
/// HCI_LE_Create_Connection command.
/// 
/// This event indicates to the Host which issued an HCI_LE_Create_Connection
/// command and received an HCI_Command_Status event if the connection creation
/// failed or was successful.
/// 
/// The Master_Clock_Accuracy parameter is only valid for a slave. On a master,
/// this parameter shall be set to 0x00.
/// 
/// Note: This event is not sent if the HCI_LE_Enhanced_Connection_Complete event
/// (see Section 7.7.65.10) is unmasked.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.65.1
pub const ConnectionComplete = @This();

pub const Code = 0x3E;

test "ConnectionComplete decode " {
  //TODO: implement test
  std.log.warn("unimplemented", .{});}
