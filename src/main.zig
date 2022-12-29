const std = @import("std");
const zig_serial = @import("serial");

pub const HCI = @import("hci.zig");
pub const HCICommand = @import("hci/command.zig");

pub fn main() !u8 {
    const port_name = "/dev/ttyUSB1";

    var serial = std.fs.cwd().openFile(port_name, .{ .mode = .read_write }) catch |err| switch (err) {
        error.FileNotFound => {
            try std.io.getStdOut().writer().print("The serial port {s} does not exist.\n", .{port_name});
            return 1;
        },
        else => return err,
    };
    defer serial.close();

    try zig_serial.configureSerialPort(serial, zig_serial.SerialConfig{
        .baud_rate = 115200,
        .word_size = 8,
        .parity = .none,
        .stop_bits = .one,
        .handshake = .hardware,
    });
    const allocator = std.heap.page_allocator;
    var command = HCI.Command.ReadLocalName.init();

    var encoded = try command.encode(allocator);
    defer allocator.free(encoded);


    var buffer = try allocator.alloc(u8, 257);
    defer allocator.free(buffer);
    std.mem.set(u8, buffer, 0);

    buffer[0] = 0x01;
    std.mem.copy(u8, buffer[1..], encoded);
    var full_command_to_send = buffer[0..encoded.len + 1];
    try serial.writer().writeAll(full_command_to_send);
    std.log.info("wrote: {s}", .{std.fmt.fmtSliceEscapeLower(full_command_to_send)});
    while (true) {
        var read = try serial.reader().readByte();
        std.log.info("got byte: {x}", .{read});
        // var packet_type = try serial.reader().readEnum(HCI.PacketType, .Little);
        // std.log.info("got packet: {any}", .{packet_type});
    }

    return 0;
}

test {
  std.testing.refAllDecls(@This());
}