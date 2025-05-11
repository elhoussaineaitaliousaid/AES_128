library ieee ;
use ieee.std_logic_1164.all ;

entity AddKey_tb is 
end entity ;
 
architecture AddKey_tb_arch of AddKey_tb is

    signal data_in_tb : std_logic_vector(127 downto 0) ;
    signal key_tb     : std_logic_vector(127 downto 0) ;
    signal data_out_tb: std_logic_vector(127 downto 0) ;

    component AddKey is 
        port (
            data_in  : in  std_logic_vector(127 downto 0);
            key      : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component ;

begin

    DUT : AddKey 
        port map (
            data_in  => data_in_tb,
            key      => key_tb,
            data_out => data_out_tb
        );

    stimulus : process 
    begin
        report "Début du test" ;
        data_in_tb <= x"000102030405060708090A0B0C0D0E0F" ;
        key_tb     <= x"00010A030405010708090A0B010D0E00" ;
        wait for 5 ns ;

        
        assert data_out_tb = x"0001080000000700000000000D000E0F"
        report "Test échoué : data_out incorrect"
        severity error ;
        wait;
    end process ;

end architecture ;
