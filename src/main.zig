/// Example implementation for testing
/// individual zBLE features

const std = @import("std");
const os = std.os;

// Helper for configuring serial ports
const zig_serial = @import("serial");

/// ZBLE main interface
const zble = @import("zble");

/// GAP interface for Generic Access
const GAP = zble.GAP;

/// ATT interface for Attribute protocol
const ATT = zble.ATT;

/// Assigned numbers for enums common types
const AssignedNumbers = zble.AssignedNumbers;

/// Advertising Data helper
const AdvertisingData = zble.AdvertisingData;

/// Use the `serial` package to open a port
/// returns the File
pub fn openPort(name: []const u8) !std.fs.File {
    var serial = try std.fs.cwd().openFile(name, .{ .mode = .read_write, .lock = .Exclusive });
    errdefer serial.close();

    try zig_serial.configureSerialPort(serial, .{
        .baud_rate = 115200,
        .word_size = 8,
        .parity = .none,
        .stop_bits = .one,
        .handshake = .hardware,
    });

    var fl_flags = os.fcntl(serial.handle, os.F.GETFL, 0) catch |err| switch (err) {
        error.FileBusy => unreachable,
        error.Locked => unreachable,
        error.PermissionDenied => unreachable,
        error.DeadLock => unreachable,
        error.LockedRegionLimitExceeded => unreachable,
        else => |e| return e,
    };
    fl_flags |= @as(usize, os.O.NONBLOCK);
    _ = os.fcntl(serial.handle, os.F.SETFL, fl_flags) catch |err| switch (err) {
        error.FileBusy => unreachable,
        error.Locked => unreachable,
        error.PermissionDenied => unreachable,
        error.DeadLock => unreachable,
        error.LockedRegionLimitExceeded => unreachable,
        else => |e| return e,
    };
    return serial;
}

pub fn advertisingData(allocator: std.mem.Allocator) ![31]u8 {
    const named_flags: AssignedNumbers.Flags = .{.named = .{
        .le_limited_discoverable_mode = 0,
        .le_general_discoverable_mode = 1,
        .br_edr_not_supported         = 1,
        .le_br_edr_supported          = 0,
        ._unused                      = 0 
    }};
    const flags = AdvertisingData.Field(.Flags, &[1]u8{@intCast(u8, named_flags.data)});
    const complete_local_name = AdvertisingData.Field(.CompleteLocalName, "zBLE");
    const advertising_data_arr = [_]*const AdvertisingData{&flags, &complete_local_name};
    const advertising_data = try AdvertisingData.encodeAll(&advertising_data_arr, allocator);
    return advertising_data;
}

pub fn main() !void {
    const port_name = "/dev/ttyUSB0";

    var port = try openPort(port_name);
    defer port.close();

    // responsible for all memory operations
    // within the zble context
    const allocator = std.heap.page_allocator;

    // context for interfacing BLE
    var ctx = try zble.Context.init(
        allocator, 
        port.reader(),
        port.writer(),
    );
    defer ctx.deinit();

    var transport = ctx.transport;
    errdefer {
        std.log.err("HCI error. Draining: ", .{});
        transport.drain(255) catch {};
    }
    
    // reset the baseband layer
    try ctx.reset();

    // gap handler
    var gap = try GAP.init(.Peripheral);
    defer gap.deinit();

    // todo fix order
    try gap.startAdveretising();
    const advertising_data = try advertisingData(ctx.allocator);
    try gap.setAdvertisingData(advertising_data);

    // att handler
    var db = try ATT.DB.init(ctx.allocator, 5);
    defer db.deinit();

    // handles server operations for Attributes
    var att_server = try ATT.Server.init(&db);
    defer att_server.deinit();

    // attach the HCI layer to relevant upper layers
    try gap.attachContext(&ctx);
    try att_server.attachContext(&ctx);

    // main run loop
    while(true) {
        // receive a packet
        ctx.run() catch |err| switch(err) {
            error.WouldBlock => continue,
            else => |e| return e
        };

        // process handlers
        ctx.runForHandlers();
        
        // process GAP
        try gap.runForContext(&ctx);

        // Process att messages
        try att_server.runForContext(&ctx);
    }
}
