const std = @import("std");

/// Server for handling ATT operations
pub const Server = @import("att/server.zig");

/// Database for storing and retreiving attributes
pub const DB = @import("att/db.zig"); 

pub const ErrorResponse           = @import("att/pdu/error_response.zig");
pub const ExchangeMTURequest      = @import("att/pdu/exchange_mtu_request.zig");
pub const ExchangeMTUResponse     = @import("att/pdu/exchange_mtu_response.zig");
pub const ExecuteWriteRequest     = @import("att/pdu/execute_write_request.zig");
pub const ExecuteWriteResponse    = @import("att/pdu/execute_write_response.zig");
pub const FindByTypeValueRequest  = @import("att/pdu/find_by_type_value_request.zig");
pub const FindByTypeValueResponse = @import("att/pdu/find_by_type_value_response.zig");
pub const FindInformationRequest  = @import("att/pdu/find_information_request.zig");
pub const FindInformationResponse = @import("att/pdu/find_information_response.zig");
pub const HandleValueIndication   = @import("att/pdu/handle_value_indication.zig");
pub const HandleValueConfirmation = @import("att/pdu/handle_value_confirmation.zig");
pub const PrepareWriteRequest     = @import("att/pdu/prepare_write_request.zig");
pub const PrepareWriteResponse    = @import("att/pdu/prepare_write_response.zig");
pub const ReadBlobRequest         = @import("att/pdu/read_blob_request.zig");
pub const ReadBlobResponse        = @import("att/pdu/read_blob_response.zig");
pub const ReadByTypeRequest       = @import("att/pdu/read_by_type_request.zig");
pub const ReadByTypeResponse      = @import("att/pdu/read_by_type_response.zig");
pub const ReadByGroupTypeRequest  = @import("att/pdu/read_by_group_type_request.zig");
pub const ReadByGroupTypeResponse = @import("att/pdu/read_by_group_type_response.zig");
pub const ReadRequest             = @import("att/pdu/read_request.zig");
pub const ReadResponse            = @import("att/pdu/read_response.zig");
pub const HandleValueNotification = @import("att/pdu/handle_value_notification.zig");
pub const WriteCommand            = @import("att/pdu/write_command.zig");
pub const WriteRequest            = @import("att/pdu/write_request.zig");
pub const WriteResponse           = @import("att/pdu/write_response.zig");

/// ATT PDU Operation Code
pub const Opcode = enum(u8) {
  error_response              = ErrorResponse.Opcode,
  exchange_mtu_request        = ExchangeMTURequest.Opcode,
  exchange_mtu_response       = ExchangeMTUResponse.Opcode,
  execute_write_request       = ExecuteWriteRequest.Opcode,
  execute_write_response      = ExecuteWriteResponse.Opcode,
  find_by_type_value_request  = FindByTypeValueRequest.Opcode,
  find_by_type_value_response = FindByTypeValueResponse.Opcode,
  find_information_request    = FindInformationRequest.Opcode,
  find_information_response   = FindInformationResponse.Opcode,
  handle_value_indication     = HandleValueIndication.Opcode,
  handle_value_confirmation   = HandleValueConfirmation.Opcode,
  prepare_write_request       = PrepareWriteRequest.Opcode,
  prepare_write_response      = PrepareWriteResponse.Opcode,
  read_blob_request           = ReadBlobRequest.Opcode,
  read_blob_response          = ReadBlobResponse.Opcode,
  read_by_type_request        = ReadByTypeRequest.Opcode,
  read_by_type_response       = ReadByTypeResponse.Opcode,
  read_by_group_type_request  = ReadByGroupTypeRequest.Opcode,
  read_by_group_type_response = ReadByGroupTypeResponse.Opcode,
  read_request                = ReadRequest.Opcode,
  read_response               = ReadResponse.Opcode,
  handle_value_notification   = HandleValueNotification.Opcode,
  write_command               = WriteCommand.Opcode,
  write_request               = WriteRequest.Opcode,
  write_response              = WriteResponse.Opcode,
  _
};

pub const PDUType = enum {
  /// Command
  cmd,
  // req,
  // rsp,
  // ntf
};

pub const Command = union(Opcode) {
  error_response:              ErrorResponse,
  exchange_mtu_request:        ExchangeMTURequest,
  exchange_mtu_response:       ExchangeMTUResponse,
  execute_write_request:       ExecuteWriteRequest,
  execute_write_response:      ExecuteWriteResponse,
  find_by_type_value_request:  FindByTypeValueRequest,
  find_by_type_value_response: FindByTypeValueResponse,
  find_information_request:    FindInformationRequest,
  find_information_response:   FindInformationResponse,
  handle_value_indication:     HandleValueIndication,
  handle_value_confirmation:   HandleValueConfirmation,
  prepare_write_request:       PrepareWriteRequest,
  prepare_write_response:      PrepareWriteResponse,
  read_blob_request:           ReadBlobRequest,
  read_blob_response:          ReadBlobResponse,
  read_by_type_request:        ReadByTypeRequest,
  read_by_type_response:       ReadByTypeResponse,
  read_by_group_type_request:  ReadByGroupTypeRequest,
  read_by_group_type_response: ReadByGroupTypeResponse,
  read_request:                ReadRequest,
  read_response:               ReadResponse,
  handle_value_notification:   HandleValueNotification,
  write_command:               WriteCommand,
  write_request:               WriteRequest,
  write_response:              WriteResponse,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      inline else => |pdu| writer.print("Command{{{any}}}", .{pdu})
    };
  }
};

pub const Handle = u16;
pub const TypeUUID = enum {
  uuid16,
  uuid128
};
pub const Type = union(TypeUUID) {
  uuid16:  u16,
  uuid128: u128,
};
pub const GroupType     = Type;
pub const AttributeType = Type;

/// Single ATT frame
pub const PDU = union(PDUType) {
  cmd: Command,
  pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) std.os.WriteError!void {
    return switch(value) {
      .cmd => |pdu| writer.print("ATT{{{any}}}", .{pdu})
    };
  }
};

test {
  std.testing.refAllDecls(DB);
  std.testing.refAllDecls(Server);

  std.testing.refAllDecls(ErrorResponse);
  std.testing.refAllDecls(ExchangeMTURequest);
  std.testing.refAllDecls(ExchangeMTUResponse);
  std.testing.refAllDecls(ExecuteWriteRequest);
  std.testing.refAllDecls(ExecuteWriteResponse);
  std.testing.refAllDecls(FindByTypeValueRequest);
  std.testing.refAllDecls(FindByTypeValueResponse);
  std.testing.refAllDecls(FindInformationRequest);
  std.testing.refAllDecls(FindInformationResponse);
  std.testing.refAllDecls(HandleValueIndication);
  std.testing.refAllDecls(HandleValueConfirmation);
  std.testing.refAllDecls(PrepareWriteRequest);
  std.testing.refAllDecls(PrepareWriteResponse);
  std.testing.refAllDecls(ReadBlobRequest);
  std.testing.refAllDecls(ReadBlobResponse);
  std.testing.refAllDecls(ReadByTypeRequest);
  std.testing.refAllDecls(ReadByTypeResponse);
  std.testing.refAllDecls(ReadByGroupTypeRequest);
  std.testing.refAllDecls(ReadByGroupTypeResponse);
  std.testing.refAllDecls(ReadRequest);
  std.testing.refAllDecls(ReadResponse);
  std.testing.refAllDecls(HandleValueNotification);
  std.testing.refAllDecls(WriteCommand);
  std.testing.refAllDecls(WriteRequest);
  std.testing.refAllDecls(WriteResponse);
}
