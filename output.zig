const std = @import("std");

const UUID = extern union {uuid16: u16, uuid128: u128};

const Characteristic = extern struct {
  uuid: UUID
};

const Service = extern struct {
  uuid: UUID,
  characteristics: [*]const Characteristic
};

const Profile = extern struct {
  magic: u32,
  services: [*]const Service,
};

const fdt = @import("support/dtc/fdt.zig");
const dtb = @embedFile("battery-service.dtb");
const header = fdt.decodeHeader(dtb) catch unreachable;

const profile0: Profile = .{.magic = header.magic, .services = &[_] Service {
  .{.uuid = .{.uuid16 = 0x180F}, .characteristics = &[_] Characteristic {
    .{.uuid = .{.uuid128 = 0x2A19}}
  }}
}};

comptime {
  @export(profile0, .{ .name = "profile0", .linkage = .Strong });
}