const std = @import("std");

pub const TokenType = enum(u32) {
  fdt_begin_node = 0x00000001,
  fdt_end_node   = 0x00000002,
  fdt_prop       = 0x00000003,
  fdt_noop       = 0x00000004,
  fdt_end        = 0x00000009
};

pub const FDTBeginNode = struct {
  name: [:0]const u8,
};

pub const FDTProp = struct {
  len: u32,
  nameoff: u32,
  data: []const u8,
};

pub const Token = union(TokenType) {
  fdt_begin_node: FDTBeginNode,
  fdt_end_node:   u32,
  fdt_prop:       FDTProp,
  fdt_noop:       u32,
  fdt_end:        u32
};
const log = std.log.scoped(.fdt);

pub const Header = packed struct {
  magic: u32,
  totalsize: u32,
  off_dt_struct: u32,
  off_dt_strings: u32,
  off_mem_rsvmap: u32,
  version: u32,
  last_comp_version: u32,
  boot_cpuid_phys: u32,
  size_dt_strings: u32,
  size_dt_struct: u32,
};

pub fn decodeHeader(fdt: []const u8) !Header {
  var header               = std.mem.zeroes(Header);
  header.magic             = std.mem.readInt(u32, fdt[ 0..4 ], .Big);
  header.totalsize         = std.mem.readInt(u32, fdt[ 4..8 ], .Big);
  header.off_dt_struct     = std.mem.readInt(u32, fdt[ 8..12], .Big);
  header.off_dt_strings    = std.mem.readInt(u32, fdt[12..16], .Big);
  header.off_mem_rsvmap    = std.mem.readInt(u32, fdt[16..20], .Big);
  header.version           = std.mem.readInt(u32, fdt[20..24], .Big);
  header.last_comp_version = std.mem.readInt(u32, fdt[24..28], .Big);
  header.boot_cpuid_phys   = std.mem.readInt(u32, fdt[28..32], .Big);
  header.size_dt_strings   = std.mem.readInt(u32, fdt[32..36], .Big);
  header.size_dt_struct    = std.mem.readInt(u32, fdt[36..40], .Big);
  return header;
}

pub fn decodeToken(fdt: []const u8) !Token {
  std.debug.assert(fdt.len >= 4);
  var token_type: ?TokenType = null;
  const token_type_data = std.mem.readInt(u32, fdt[0..4], .Big);

  // log.err("type={x:8}", .{token_type_data});
  // for(fdt)|c|{std.debug.print("{x:2>0},", .{c});}
  token_type = @intToEnum(TokenType, token_type_data);
  return switch(token_type.?) {
    .fdt_begin_node => .{.fdt_begin_node = fdt_begin_node(fdt[4..])},
    .fdt_end_node => .{.fdt_end_node = 0},
    .fdt_prop => .{.fdt_prop = fdt_prop(fdt[4..])},
    .fdt_noop => .{.fdt_noop = 0},
    .fdt_end => .{.fdt_end = 0},
  };
}

fn fdt_begin_node(node: []const u8) FDTBeginNode {
  var end: usize = 0;

  for(node) |c,i| {
    if(c == 0) {
      end = i;
      break;
    }
  }
  const ptr = node[0..end:0];
  // log.err("ptr={s}", .{ptr});
  return .{.name = ptr};
}

fn fdt_prop(node: []const u8) FDTProp {
  const len = std.mem.readInt(u32, node[0..4], .Big);
  const end = 8 + len ;
  const nameoff = std.mem.readInt(u32, node[4..8], .Big);
  // log.err("prop.len={d} prop.name={d}", .{len, nameoff});
  return .{.len = len, .nameoff = nameoff, .data = node[8..end]};
}

test {
  var file = try std.fs.cwd().openFile("battery-service.dtb", .{});
  defer file.close();
  const buffer_size = 0xffff;
  const file_buffer = try file.readToEndAlloc(std.testing.allocator, buffer_size);
  defer std.testing.allocator.free(file_buffer);
  const header = try decodeHeader(file_buffer);
  log.err("header={any}", .{header});

  const dt_struct_end = header.off_dt_struct+header.size_dt_struct;
  var index = header.off_dt_struct;
  
  while(index < dt_struct_end) {
    var token = try decodeToken(file_buffer[index..dt_struct_end]);
    switch(token) {
      .fdt_begin_node => |begin_node| {
        const end = index+@sizeOf(TokenType)+begin_node.name.len+1; // +1 for nul term
        const len = file_buffer[end..dt_struct_end].len;
        const rem = @rem(len, @sizeOf(u32));
        index = @intCast(u32, end + rem);
      }, 
      .fdt_end_node, .fdt_noop, .fdt_end => index += @sizeOf(TokenType),
      .fdt_prop => |prop| {
        const prop_end = index+@sizeOf(TokenType)+@sizeOf(u32)+@sizeOf(u32)+prop.len; 
        const len = file_buffer[prop_end..dt_struct_end].len;
        const rem = @rem(len, @sizeOf(u32));
        index = @intCast(u32, prop_end + rem);
      },
    }
    log.err("token={any}", .{token});
  }
}