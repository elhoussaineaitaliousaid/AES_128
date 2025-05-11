library ieee;
use ieee.std_logic_1164.all;
use work.types_pkg.all;

entity ShiftRows is
    port (
        data_in_SR  : in  std_logic_vector(127 downto 0);
        data_out_SR : out std_logic_vector(127 downto 0)
    );
end entity;

architecture ShiftRows_arch of ShiftRows is
    signal data_in_array  : array_bytes;
    signal data_shifted   : array_bytes;
begin

    process(data_in_SR)
    begin
        for i in 0 to 15 loop
            data_in_array(i) <= data_in_SR((127 - i*8) downto (120 - i*8));
        end loop;
    end process;

    process(data_in_array)
    begin
 
        data_shifted(0)  <= data_in_array(0);
        data_shifted(4)  <= data_in_array(4);
        data_shifted(8)  <= data_in_array(8);
        data_shifted(12) <= data_in_array(12);
        data_shifted(1)  <= data_in_array(5);
        data_shifted(5)  <= data_in_array(9);
        data_shifted(9)  <= data_in_array(13);
        data_shifted(13) <= data_in_array(1);
        data_shifted(2)  <= data_in_array(10);
        data_shifted(6)  <= data_in_array(14);
        data_shifted(10) <= data_in_array(2);
        data_shifted(14) <= data_in_array(6);
        data_shifted(3)  <= data_in_array(15);
        data_shifted(7)  <= data_in_array(3);
        data_shifted(11) <= data_in_array(7);
        data_shifted(15) <= data_in_array(11);
    end process;

    process(data_shifted)
    begin
        for i in 0 to 15 loop
            data_out_SR((127 - i*8) downto (120 - i*8)) <= data_shifted(i);
        end loop;
    end process;

end architecture;
