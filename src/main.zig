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

    var scan_enable = HCI.Command.WriteScanEnable.init();
    scan_enable.scan_enable = .None;
    var packet: HCI.Packet = .{.command = .{.write_scan_enable = scan_enable}};

    const reader = serial.reader();
    const writer = serial.writer();
    var transport = HCI.Transport.Uart.init(allocator, reader, writer);
    
    try transport.write(packet);

    packet = try transport.receive();
    std.log.info("received packet: {any}", .{packet});

    var write_local_name = HCI.Command.WriteLocalName.init();
    packet = .{.command = .{.write_local_name = write_local_name}};
    try transport.write(packet);
    packet = try transport.receive();
    std.log.info("received packet: {any}", .{packet});

    var read_local_version = HCI.Command.ReadLocalVersion.init();
    packet = .{.command = .{.read_local_version = read_local_version}};
    try transport.write(packet);
    packet = try transport.receive();
    std.log.info("received packet: {any}", .{packet});

    var set_event_mask = HCI.Command.SetEventMask.init();
    packet = .{.command = .{.set_event_mask = set_event_mask}};
    try transport.write(packet);
    packet = try transport.receive();
    std.log.info("received packet: {any}", .{packet});

    while(true) {
        var r = try reader.readByte();
        std.log.info("unhandled byte. hex={x} dec={d}", .{r, r});
    }

    return 0;
}

test {
  std.testing.refAllDecls(@This());
}