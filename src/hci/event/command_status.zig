const std = @import("std");

/// The HCI_Command_Status event is used to indicate that the command described by
/// the Command_Opcode parameter has been received, and that the Controller is
/// currently performing the task for this command.
/// 
/// This event is needed to provide mechanisms for asynchronous operation, which
/// makes it possible to prevent the Host from waiting for a command to finish. If
/// the command cannot begin to execute (a parameter error may have occurred, or the
/// command may currently not be allowed), the Status event parameter will contain
/// the corresponding error code, and no complete event will follow since the
/// command was not started. The Num_HCI_Command_Packets event parameter allows the
/// Controller to indicate the number of HCI command packets the Host can send to
/// the Controller. If the Controller requires the Host to stop sending commands,
/// the Num_HCI_Command_Packets event parameter will be set to zero. To indicate to
/// the Host that the Controller is ready to receive HCI command packets, the
/// Controller generates an HCI_Command_Status event with Status 0x00 and
/// Command_Opcode 0x0000 and the Num_HCI_Command_Packets event parameter set to 1
/// or more. Command_Opcode 0x0000 is a special value indicating that this event is
/// not associated with a command sent by the Host. The Controller can send an
/// HCI_Command_Status event with Command Opcode 0x0000 at any time to change the
/// number of outstanding HCI command packets that the Host can send before waiting.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.15
pub const CommandStatus = @This();

pub const Code = 0xF;

test "CommandStatus decode " {
  //TODO: implement test
  std.log.warn("unimplemented", .{});}
