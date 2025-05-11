library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mixcolomun_tb is
end entity;

architecture Mixcolomun_tb_arch of Mixcolomun_tb is
    signal i_data_tb : std_logic_vector(127 downto 0);
    signal o_data_tb : std_logic_vector(127 downto 0);

    component Mixcolomn is
        port (
            data_in_mx  : in  std_logic_vector(127 downto 0);
            data_out_mx : out std_logic_vector(127 downto 0)
        );
    end component;

begin
    DUT : Mixcolomn port map(
        data_in_mx  => i_data_tb,
        data_out_mx => o_data_tb
    );

    Stimulus : process
    begin
        report "Début du test";

        i_data_tb <= x"000102030405060708090A0B0C0D0E0F";
        wait for 5 ns;
        report "Valeur de sortie obtenue : " & to_hstring(o_data_tb);
        assert o_data_tb = x"04050607141516172425262734353637"  
        report "Test échoué : o_data_tb incorrect"
        severity error;

        report "Test réussi";
        wait;
    end process;

end architecture;
