library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity Mixcolomun is 
    port (
        data_in_mx  : in  std_logic_vector(127 downto 0);
        data_out_mx : out std_logic_vector(127 downto 0)
    );
end entity;

architecture Mixcolomn_arch of Mixcolomun is 
    signal dt_in_array  : array_bytes; 
    signal dt_out_array : array_bytes;

    -- Multiplication by 2 
    function mul_by_2(byte: std_logic_vector(7 downto 0)) return std_logic_vector is 
        variable result : std_logic_vector(7 downto 0);
    begin
        if byte(7) = '0' then 
            result := (byte(6 downto 0) & '0');
        else 
            result := (byte(6 downto 0) & '0') xor x"1B";
        end if;
        return result;
    end function;

    -- Multiplication by 3
    function mul_by_3(byte: std_logic_vector(7 downto 0)) return std_logic_vector is
    begin
        return mul_by_2(byte) xor byte;
    end function;

begin

    -- Input vector to byte array
    process(data_in_mx)
    begin
        for i in 0 to 15 loop
            dt_in_array(i) <= data_in_mx((127 - i*8) downto (120 - i*8));
        end loop;
    end process;

    -- MixColumn operation
    process(dt_in_array)
        variable s0, s1, s2, s3 : std_logic_vector(7 downto 0);
        variable r0, r1, r2, r3 : std_logic_vector(7 downto 0);
    begin
        for c in 0 to 3 loop
            s0 := dt_in_array(c);      
            s1 := dt_in_array(c+4);     
            s2 := dt_in_array(c+8);     
            s3 := dt_in_array(c+12);    

            r0 := mul_by_2(s0) xor mul_by_3(s1) xor s2 xor s3;
            r1 := s0 xor mul_by_2(s1) xor mul_by_3(s2) xor s3;
            r2 := s0 xor s1 xor mul_by_2(s2) xor mul_by_3(s3);
            r3 := mul_by_3(s0) xor s1 xor s2 xor mul_by_2(s3);

            dt_out_array(c)    <= r0;
            dt_out_array(c+4)  <= r1;
            dt_out_array(c+8)  <= r2;
            dt_out_array(c+12) <= r3;
        end loop;
    end process;

    process(dt_out_array)
    begin
        for i in 0 to 15 loop
            data_out_mx((127 - i*8) downto (120 - i*8)) <= dt_out_array(i);
        end loop;
    end process;

end architecture;
