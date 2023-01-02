
const ATT = @import("../../att.zig");

/// Only attributes with attribute handles between and including the Starting
/// Handle parameter and the Ending Handle parameter that match the requested
/// attribute type and the attribute value that have sufficient permissions to allow
/// reading will be returned. To read all attributes, the Starting Handle parameter
/// shall be set to 0x0001, and the Ending Handle parameter shall be set to
/// 0xFFFF.
/// If one or more handles will be returned, an
/// ATT_FIND_BY_TYPE_VALUE_RSP PDU shall be sent.
/// Note: Attribute values will be compared in terms of length and binary
/// representation.
/// Note: It is not possible to use this request on an attribute that has a value
/// longer than (ATT_MTU-7).
/// If a server receives an ATT_FIND_BY_TYPE_VALUE_REQ PDU with the
/// Starting Handle parameter greater than the Ending Handle parameter or the
/// Starting Handle parameter is 0x0000, an ATT_ERROR_RSP PDU shall be
/// sent with the Error Code parameter set to Invalid Handle (0x01). The Attribute
/// Handle In Error parameter shall be set to the Starting Handle parameter
pub const Opcode = 0x06;
starting_handle: ATT.Handle,
ending_handle:   ATT.Handle,
attribute_type:  ?[]u8,
