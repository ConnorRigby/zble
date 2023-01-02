const std = @import("std");

const ATT = @import("../../att.zig");

pub const Opcode = 1;

pub const ErrorCode = enum(u8) {
  InvalidHandle = 0x0,
  ReadNotPermitted = 0x2,
  WriteNotPermitted = 0x3,
  InvalidPDU = 0x4,
  InsufficientAuthentication = 0x05,
  RequestNotSupported = 0x06,
  InvalidOffset = 0x07,
  InsufficientAuthorization = 0x08,
  PrepareQueueFull = 0x09,
  AttributeNotFound = 0x0A,
  AttributeTooLong = 0x0B,
  EncryptionKeySizeTooShort = 0x0C,
  InvalidAttributeValueLength = 0x0D,
  UnlikelyError = 0x0E,
  InsufficientEncryption = 0x0F,
  UnsupportedGroupType = 0x10,
  InsufficientResource = 0x11,
  DatabaseOutOfSync = 0x12,
  ValueNotAllowed = 0x13,
  // application error = 0x80=0x9F
  // common profile and service error codes = 0xE0-0xFF
  // defined in Core Specification Supplement, Part B, Common Profile and Service Error Codes
  _
};

request_opcode: ATT.Opcode,
request_handle: ATT.Handle,
error_code:     ErrorCode,
