const std = @import("std");

/// > The Inquiry Complete event indicates that the Inquiry is finished. This event contains a
/// > Status parameter, which is used to indicate if the Inquiry completed successfully or if the
/// > Inquiry was not completed.
/// 
/// Reference: Version 5.2, Vol 4, Part E, 7.7.1
pub const InquiryComplete = @This();

pub const Code = 0x1;

test "InquiryComplete decode " {
  //TODO: implement test
  std.log.warn("unimplemented", .{});}
