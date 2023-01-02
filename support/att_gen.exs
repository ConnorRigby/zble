pdus = ~w(exchange_mtu_request exchange_mtu_response execute_write_request execute_write_response find_by_type_value_request find_by_type_value_response find_information_request find_information_response handle_value_indication handle_value_confirmation prepare_write_request prepare_write_response read_blob_request read_blob_response read_by_type_request read_by_type_response read_by_group_type_request read_by_group_type_response read_request read_response handle_value_notification write_command write_request write_response)
for pdu <- pdus do
  File.write("src/att/pdu/#{pdu}.zig", """
  const Opcode = -1; // FIXME
  """)
end
