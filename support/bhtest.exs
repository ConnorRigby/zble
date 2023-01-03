Mix.install([
  {:blue_heron, path: "support/blue_heron", override: true},
  {:blue_heron_transport_uart, ">= 0.0.0"}
])
config = struct BlueHeronTransportUART, %{device: "ttyUSB0", uart_opts: [speed: 115200]}
{:ok, ctx} = BlueHeron.transport(config)
advertising_data = <<0x02, 0x01, 0b00000110>> <> <<0x09, 0x09, "MyApp-XY">>
en = BlueHeron.HCI.Command.LEController.SetAdvertisingEnable.new(advertising_enable: true)
cmd = BlueHeron.HCI.Command.LEController.SetAdvertisingData.new(advertising_data: advertising_data)
BlueHeron.hci_command(ctx, cmd)
BlueHeron.hci_command(ctx, en)

BlueHeron.add_event_handler(ctx)

defmodule FakeGAP do
  alias ElixirSense.Core.BuiltinAttributes
  def receive_packet(ctx) do
    receive do
      {:HCI_ACL_DATA_PACKET,
      %BlueHeron.ACL{
        handle: _,
        flags: %{bc: 2, pb: 0},
        data: %BlueHeron.L2Cap{
          data: %BlueHeron.ATT.ExchangeMTURequest{opcode: _, client_rx_mtu: 527},
          cid: 4
        }
      } = acl } ->
        reply = %{acl | flags: %{pb: 0, bc: 0}, data: %{acl.data | data: %BlueHeron.ATT.ExchangeMTUResponse{server_rx_mtu: 23}}}
        BlueHeron.acl(ctx, reply)
        receive_packet(ctx)
      oops ->
        IO.inspect(oops, label: "unknown")
        receive_packet(ctx)
    end
  end
end

FakeGAP.receive_packet(ctx)

Process.sleep(:infinity)
