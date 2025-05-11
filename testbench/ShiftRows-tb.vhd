library ieee;
use ieee.std_logic_1164.all;
use work.all;


entity ShiftRows_tb is
end entity;

architecture ShiftRows_tb_arch of ShiftRows_tb is

    signal data_in_tb  : std_logic_vector(127 downto 0);
    signal data_out_tb : std_logic_vector(127 downto 0);

    component ShiftRows is
        port (
            data_in_SR  : in  std_logic_vector(127 downto 0);
            data_out_SR : out std_logic_vector(127 downto 0)
        );
    end component;

begin

    DUT: ShiftRows
    port map (
        data_in_SR  => data_in_tb,
        data_out_SR => data_out_tb
    );

    stimulus: process
    begin
        report "Test start";
        data_in_tb <= x"000102030405060708090A0B0C0D0E0F";
        wait for 5 ns;
        assert data_out_tb = x"00030A0E04090E03080D02070C01060B"
        report "Test failed"
        severity error;
        wait for 10 ns;
        wait;
    end process;

end architecture;
