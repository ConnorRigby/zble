zig cc -C -Isupport/btstack/src/ -Igatt -xassembler-with-cpp -E -P -o- gatt/example.dts
zig cc -Igatt -Isupport/btstack/src/ -xassembler-with-cpp -E -P  -O3 -o- gatt/example.dts 2>1 | ./zig-out/bin/dtc -o example.dtb -Wno-unit_address_format -Wno-pci_device_reg -Wno-pci_device_bus_num -Wno-simple_bus_reg -Wno-i2c_bus_reg -Wno-spi_bus_reg
support/btstack/src/bluetooth_gatt.h
