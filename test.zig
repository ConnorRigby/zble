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
pub fn main() void {
  const profile0 = @extern(?*Profile, .{.name="profile0", .linkage = .Strong});
  _ = profile0;
}
