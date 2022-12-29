const std = @import("std");
const zig_serial = @import("serial");

pub const HCI = @import("hci.zig");

pub fn main() !u8 {
    const port_name = "/dev/ttyUSB0";

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
    // var command = HCI.Command.Reset.init();
    // var command = HCI.Command.ReadLocalName.init();
    var command = HCI.Command.ReadLocalVersion.init();

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
    const reader = serial.reader();
    var packet = try HCI.Transport.Uart.receive_packet(reader);
    std.log.info("received packet: {any}", .{packet});

    // while (true) {
    //     var packet_type = try reader.readEnum(HCI.PacketType, .Little);
    //     switch(packet_type) {
    //         .Event => {
    //             var event_type = try reader.readEnum(HCI.Event.Code, .Little);
    //             switch(event_type) {
    //                 .command_complete => {
    //                     var num_hci_commands = try reader.readByte();
    //                     var size = try reader.readByte();
    //                     std.log.info("size={d} num_hci_commands={d}", .{size, num_hci_commands});
    //                     // var opcode = try reader.readInt(u16, .Little);
    //                     var opcode = try reader.readEnum(HCI.Command.OPC, .Big);
    //                     std.log.info("opcode={any}", .{opcode});
    //                     break;
    //                 },
    //                 else => |e| {
    //                     std.log.err("unexpected event type: {any}", .{e});
    //                     break;
    //                 }
    //             }
    //         },
    //         else => |p| {
    //             std.log.err("unexpected packet type: {any}", .{p});
    //             break;
    //         }
    //     }
    // }

    while(true) {
        var r = try reader.readByte();
        std.log.info("unhandled byte. hex={x} dec={d}", .{r, r});
    }

    return 0;
}

test {
  std.testing.refAllDecls(@This());
}