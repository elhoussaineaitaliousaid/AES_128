library ieee ;
use ieee.std_logic_1164.all ;



entity suByte_tb is
 end entity ;



architecture suByte_tb_arch of suByte_tb is 
    signal data_in_tb : std_logic_vector(7 downto 0 ) ;
    signal data_out_tb : std_logic_vector(7 downto 0 ) ;
    component suByte is 
        port(
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
            );
    end component ;
         

begin 
    DUT : suByte 
    port map (  data_in_tb  => data_in,
        data_out_tb => data_out
    );
stimulus : process 
begin 
    report " test" ;
    data_in_tb <= x"00";
    wait for 5 ns ;
    assert x"00" 
      report "test failed " 
      severity error ;
    wait for 10 ns ;
    wait ; 
    

end process ;





end architecture ;
