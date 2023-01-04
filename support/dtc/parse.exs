defmodule Structure do
  def parse(data, tokens \\ [])
  def parse(<<>>, tokens) do
    Enum.reverse(tokens)
  end

  def parse(data, tokens) do
    {token, rest} = case data do
      <<0x01::32-big, rest::binary>> ->
        begin_node(rest)
      <<0x02::32-big, rest::binary>> ->
        {:end_node, rest}
      <<0x03::32-big, rest::binary>> ->
        prop(rest)
      <<0x04::32-big,rest::binary>> ->
        {:noop, rest}
      <<0x09::32-big,rest::binary>> ->
        {:end, rest}
      error ->
        {:error, error, tokens}
    end
    parse(rest, [token | tokens])
  end

  def begin_node(node, buffer \\ <<>>)

  def begin_node(<<0::8, rest::binary>>, buffer) do
    buffer = buffer <> "\0"
    pad = rem(bit_size(rest), 32)
    IO.inspect({pad / 8, byte_size(rest)}, label: buffer)
    <<0::integer-size(pad), rest::binary>> = rest
    {{:begin_node, buffer}, rest}
  end

  def begin_node(<<c::bytes-1,rest::binary>>, buffer) do
    begin_node(rest, buffer <> c)
  end

  def prop(<<length::32-big, name::32-big, data::binary-size(length), rest::binary>>) do
    pad = rem(bit_size(rest), 32)
    <<0::integer-size(pad), rest::binary>> = rest
    {{:prop, name, data}, rest}
  end
end

defmodule StringResolve do
  def resolve(tokens, strings, resolved \\ [])
  def resolve([], _strings, resolved) do
    Enum.reverse(resolved)
  end

  def resolve([{:begin_node, str} | rest], strings, resolved) do
    resolve(rest, strings, [{:begin_node, String.trim(str, "\0")} | resolved])
  end
  def resolve([{:prop, address, value} | rest], strings, resolved) do
    <<_::bytes-size(address), string::binary>> = strings
    [string | _] = String.split(string, "\0")
    resolve(rest, strings, [{:prop, string, value} | resolved])
  end
  def resolve([token | rest], strings, resolved) do
    resolve(rest, strings, [token | resolved])
  end

end

# IO.inspect(header, base: :hex, label: "header")
# IO.inspect({totalsize, byte_size(data)}, label: "data size")

# <<_::bytes-size(off_dt_struct), dt_struct::bytes-size(size_dt_struct), _::binary>> = data

fdt = File.read!("example.dtb")
<<0xD00DFEED::32-big,
  totalsize::32-big,
  off_dt_struct::32-big,
  off_dt_strings::32-big,
  off_mem_rsvmap::32-big,
  version::32-big,
  last_comp_version::32-big,
  boot_cpuid_phys::32-big,
  size_dt_strings::32-big,
  size_dt_struct::32-big,
  data::binary
>> = fdt

header = %{
  totalsize: totalsize,
  off_dt_struct: off_dt_struct,
  off_dt_strings: off_dt_strings,
  off_mem_rsvmap: off_mem_rsvmap,
  version: version,
  last_comp_version: last_comp_version,
  boot_cpuid_phys: boot_cpuid_phys,
  size_dt_strings: size_dt_strings,
  size_dt_struct: size_dt_struct,
}
<<_::bytes-size(off_dt_struct), dt_struct::bytes-size(size_dt_struct), _::binary>> = fdt
<<_::bytes-size(off_dt_strings), off_dt_strings::bytes-size(size_dt_strings), _::binary>> = fdt

Structure.parse(dt_struct)
|> StringResolve.resolve(off_dt_strings)
|> IO.inspect()
