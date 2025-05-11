library ieee ;
use ieee.std_logic_1164.all ;


entity AddKey is 
    port ( data_in : in std_logic_vector(127 downto 0);
    key : in std_logic_vector(127 downto 0);
    data_out : out std_logic_vector(127 downto 0)
    );
    end entity ;

    
    architecture AddKey_arch of AddKey is
    begin
        data_out<= data_in xor key ;
    end architecture ;