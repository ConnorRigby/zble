const std = @import("std");
// FIXME should be on a root level module, not command_complete
const CommandComplete = @import("command_complete.zig");

/// The HCI_Disconnection_Complete event occurs when a connection is terminated.
/// 
/// The status parameter indicates if the disconnection was successful or not. The
/// reason parameter indicates the reason for the disconnection if the
/// disconnection was successful. If the disconnection was not successful, the
/// value of the reason parameter shall be ignored by the Host. For example, this
/// can be the case if the Host has issued the HCI_Disconnect command and there
/// was a parameter error, or the command was not presently allowed, or a
/// Connection_Handle that didn’t correspond to a connection was given.
/// 
/// Note: When a physical link fails, one HCI_Disconnection_Complete event will be
/// returned for each logical channel on the physical link with the corresponding
/// Connection_Handle as a parameter.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.5
pub const DisconnectionComplete = @This();

pub const Code = 0x5;

handle: u12,
status: CommandComplete.ErrorCode,
reason: CommandComplete.ErrorCode,
