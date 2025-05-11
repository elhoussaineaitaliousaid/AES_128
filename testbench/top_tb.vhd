
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
   
entity top_tb is 
end entity; 
  
architecture top_tb_arch of top_tb is
constant CLK_PERIOD : time := 10 ns;
signal clk_tb : std_logic;
signal start_tb : std_logic:='0';
signal busy_tb : std_logic:='0';
signal plaintext_tb : std_logic_vector(127 downto 0):=(others =>'0');
signal valid_o_tb : std_logic :='0';
signal ciphertext_tb : std_logic_vector(127 downto 0):=(others =>'0');
signal key_tb        : std_logic_vector(127 downto 0);
signal expected_ciphertext : std_logic_vector(127 downto 0):=(others => '0');
component top_AES 
port (	clk   : in std_logic;
		start : in std_logic;
		busy  : out std_logic;
        plaintext  : in std_logic_vector(127 downto 0);
		valid_o    : out std_logic;
        ciphertext_o : out std_logic_vector(127 downto 0);
		key        : out std_logic_vector(127 downto 0));
end component;
begin
DUT : top_AES  
port map(
        clk   => clk_tb,
	    start => start_tb,
	    busy  => busy_tb ,
        plaintext  => plaintext_tb, 
		valid_o   => valid_o_tb,
        ciphertext_o => ciphertext_tb,
		key        => key_tb
        );
CLOCK : process
begin
    clk_tb <= '1'; wait for CLK_PERIOD/2;
    clk_tb <= '0'; wait for CLK_PERIOD/2;
    wait ;
end process;
STIMILUS : process
begin
-- TEST 1 
report "test 1";
plaintext_tb <= x"6bc1bee22e409f96e93d7e117393172a";
expected_ciphertext <= (others => '0');
start_tb <= '1';
wait until valid_o_tb = '1';
expected_ciphertext <= x"3ad77bb40d7a3660a89ecaf32466ef97";
start_tb <= '0';
wait for CLK_PERIOD;
wait ;


end process;
end architecture;
