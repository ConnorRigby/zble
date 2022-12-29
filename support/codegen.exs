Mix.install([{:blue_heron, path: "support/blue_heron"}])

defmodule ZBLE.Codegen do
  @commands BlueHeron.HCI.Command.__modules__()
  @events BlueHeron.HCI.Event.__modules__()

  @root_dir Path.expand(Path.join([__DIR__, "../"]))

  def gen_commands() do
    # IO.inspect(@commands, pretty: true, limit: :infinity)
    commands =
      for command <- @commands do
        ["BlueHeron", "HCI", "Command" | rest] = Module.split(command)
        path = Enum.map(rest, fn name -> Macro.underscore(name) end)
        file = List.last(path) <> ".zig"
        name = List.last(rest)
        ocf = command.__ocf__()
        [ogf_name] = List.delete_at(rest, -1)
        ogf_module = Module.concat(["BlueHeron", "HCI", "Command", ogf_name])
        ogf = ogf_module.__ogf__()
        <<opcode::16>> = command.__opcode__()
        path = Path.join([@root_dir, "src", "hci", "command" | List.replace_at(path, -1, file)])
        File.mkdir_p(Path.dirname(path))

        data = struct(command)
        fields = Map.keys(data) -- [:__struct__, :ogf, :ocf, :opcode]
        docs = case Code.fetch_docs(command) do
          {:docs_v1, 4, :elixir, "text/markdown", %{"en" => docs}, _, _} ->
            doc = String.split(docs, "\n")
            |> List.delete_at(-1)
            |> Enum.join("\n/// ")
            |> String.replace("- see `BlueHeron.ErrorCode`", "- command status code")
            "/// " <> doc <> "\n"
          _ -> ""
        end
        File.write!(path, """
        const std = @import("std");

        #{docs}pub const #{name} = @This();

        // Group Code
        pub const OGF: u6  = #{inspect(ogf, base: :hex)};
        // Command Code
        pub const OCF: u10 = #{inspect(ocf, base: :hex)};
        // Opcode
        pub const OPC: u16 = #{inspect(opcode, base: :hex)};

        // payload length
        length: usize,
        pub fn init() #{name} {
          return .{.length = 3};
        }
        #{if not Enum.empty?(fields), do: "\n// fields: #{for field <- fields, do: "\n// * #{field}"}\n"}
        // encode from a struct
        pub fn encode(self: #{name}, allocator: std.mem.Allocator) ![]u8 {
          var command = try allocator.alloc(u8, self.length);
          errdefer allocator.free(command);
          command[0] = OCF;
          command[1] = OGF << 2;
          command[2] = 0;
          // TODO: implement encoding #{name}

          return command;
        }

        // decode from a binary
        pub fn decode(payload: []u8) #{name} {
          std.debug.assert(payload[0] == OCF);
          std.debug.assert(payload[1] == OGF >> 2);
          return .{.length = payload.len};
        }

        test "#{name} decode" {
          var payload = [_]u8 {OCF, OGF >> 2, 0};
          const decoded = #{name}.decode(&payload);
          _ = decoded;
          try std.testing.expect(false);
          @panic("test not implemented yet");
        }

        test "#{name} encode" {
          const #{Macro.underscore(name)} = .{.length = 3};
          const encoded = try #{name}.encode(#{Macro.underscore(name)}, std.testing.allocator);
          defer std.testing.allocator.free(encoded);
          try std.testing.expect(encoded[0] == OCF);
          try std.testing.expect(encoded[1] == OGF >> 2);
          try std.testing.expect(false);
          @panic("test not implemented yet");
        }
        """)

        [ogf_name] = List.delete_at(rest, -1)
        %{
          ogf_name: ogf_name,
          name: name,
          file: file,
          path: path,
          ogf: ogf,
          ocf: ocf,
          opcode: opcode,
          command: command,
          data: data
        }
      end

    command_path = Path.join([@root_dir, "src", "hci", "command.zig"])
    commands = Enum.sort(commands, fn a, b -> a.ocf <= b.ocf end)

    ogfs =
      Enum.uniq_by(commands, fn %{ogf: ogf} -> ogf end)
      |> Enum.map(fn %{ogf_name: ogf_name, ogf: ogf} -> %{name: ogf_name, ogf: ogf} end)

    # IO.inspect({commands, ogfs}, label: "commands,ogfs")

    for %{name: name, ogf: ogf} <- ogfs do
      File.write!(Path.join([@root_dir, "src", "hci", "command", Macro.underscore(name) <> ".zig"]), """
      const std = @import("std");
      pub const #{name} = @This();
      pub const OGF: u6 = #{inspect(ogf, base: :hex)};

      test {
        try std.testing.expect(false);
      }
      """)
    end

    File.write!(command_path, """
    const std = @import("std");

    #{Enum.map(commands, fn %{name: name, path: path} -> imported = Path.split(path) -- Path.split(command_path)

      "pub const #{name} = @import(\"#{Path.join(imported)}\");\n" end)}

    #{Enum.map(ogfs, fn %{name: name} ->
    "pub const #{name} = @import(\"command/#{Macro.underscore(name) <> ".zig"}\");\n"
    end)}
    pub const Command = @This();

    /// Opcode Group
    pub const OGF = enum(u10) {
    #{Enum.map(ogfs, fn %{name: name, ogf: ogf} ->
      "  #{Macro.underscore(name)} = #{inspect(ogf, base: :hex)},\n"
      end)}
    };

    /// Opcode
    pub const OPC = enum(u16) {
    #{Enum.map(commands, fn %{name: name, opcode: opcode} -> "  #{Macro.underscore(name)} = #{inspect(opcode, base: :hex)},\n" end)}
    };

    pub const Header = union(OGF) {
    #{Enum.map(ogfs, fn %{name: name} -> "  #{Macro.underscore(name)}: #{name},\n" end)}
    };
    pub const Payload = union(OPC) {
    #{Enum.map(commands, fn %{name: name} -> "  #{Macro.underscore(name)}: #{name},\n" end)}
    };

    header: Header,
    payload: Payload,

    test {
      std.testing.refAllDecls(Command);
    }

    test {
      try std.testing.expect(false);
    }
    """)
  end

  def gen_events() do
    events = for event <- @events do
      ["BlueHeron", "HCI", "Event" | rest] = Module.split(event)
      path = Enum.map(rest, fn name -> Macro.underscore(name) end)
      file = List.last(path) <> ".zig"
      name = List.last(rest)
      event_code = event.__code__()

      path = Path.join([@root_dir, "src", "hci", "event" | List.replace_at(path, -1, file)])

      File.mkdir_p(Path.dirname(path))
      File.touch!(path)
      data = struct(event)
      fields = Map.keys(data) -- [:__struct__]
      docs = case Code.fetch_docs(event) do
        {:docs_v1, 4, :elixir, "text/markdown", %{"en" => docs}, _, _} ->
          doc = String.split(docs, "\n")
          |> List.delete_at(-1)
          |> Enum.join("\n/// ")
          "/// " <> doc <> "\n"
        _ -> ""
      end
      sub = if function_exported?(event, :__subevent_code__, 0), do: event.__subevent_code__()
      %{file: file, path: path, name: name, event_code: event_code, docs: docs, fields: fields, sub_event_code: sub}
      # Enum.map(path, fn n -> Path.join(@root_dir, n) end)
      # |> IO.inspect(label: "event")
    end

    for %{file: _file, path: path, name: name, event_code: event_code, docs: docs} <- events do
      File.write!(path, """
      const std = @import("std");

      #{docs}pub const #{name} = @This();

      pub const Code = #{inspect(event_code, base: :hex)};

      test "#{name} decode " {
        //TODO: implement test
        std.testing.expect(false);
      }
      """)
    end
    event_path = Path.join([@root_dir, "src", "hci", "event.zig"])
    events = Enum.sort(events, fn a, b -> a.event_code <= b.event_code end)
    File.write!(event_path, """
    const std = @import("std");
    #{Enum.map(events, fn %{name: name, path: path} ->
      imported = Path.split(path) -- Path.split(event_path)
      "pub const #{name} = @import(\"#{Path.join(imported)}\");\n"
    end)}

    pub const Code = enum(u8) {
    #{Enum.map(events, fn %{name: name, event_code: event_code, sub_event_code: sub} ->
      unless sub, do:
      "  #{Macro.underscore(name)} = #{inspect(event_code, base: :hex)},\n", else: ""
    end)}
    };


    test {
      std.testing.refAllDecls(@This());
    }
    """)
  end
end

# ZBLE.Codegen.gen_commands()
ZBLE.Codegen.gen_events()
IO.puts "done"
