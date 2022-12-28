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
        <<^ocf::little-10, ogf::little-6>> = command.__opcode__()
        <<opcode::little-16>> = command.__opcode__()
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
        pub const OGF: u8  = #{inspect(ogf, base: :hex)};
        // Command Code
        pub const OCF: u10 = #{inspect(ocf, base: :hex)};
        // Opcode
        pub const OPC: u16 = #{inspect(opcode, base: :hex)};
        #{if not Enum.empty?(fields), do: "\n// fields: #{for field <- fields, do: "\n// * #{field}"}\n"}
        // encode from a struct
        pub fn encode(self: #{name}) []u8 {
          _ = self;
          return &[_]u8{};
        }

        // decode from a binary
        pub fn decode(payload: []u8) #{name} {
          _ = payload;
          return .{};
        }

        test "#{name} decode" {
          const payload = [_]u8 {};
          const decoded = #{name}.decode(&payload);
          _ = decoded;
          try std.testing.expect(false);
          @panic("test not implemented yet");
        }

        test "#{name} encode" {
          const #{Macro.underscore(name)} = .{};
          const encoded = #{name}.encode(#{Macro.underscore(name)});
          _ = encoded;
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
    for event <- @events do
      ["BlueHeron", "HCI", "Event" | rest] = Module.split(event)
      path = Enum.map(rest, fn name -> Macro.underscore(name) end)
      file = List.last(path) <> ".zig"

      path = Path.join([@root_dir, "src", "hci", "event" | List.replace_at(path, -1, file)])
      File.mkdir_p(Path.dirname(path))

      File.touch!(path)
      # Enum.map(path, fn n -> Path.join(@root_dir, n) end)
      # |> IO.inspect(label: "event")
    end
  end
end

ZBLE.Codegen.gen_commands()
ZBLE.Codegen.gen_events()
IO.puts "done"
