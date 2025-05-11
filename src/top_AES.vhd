library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
   
entity top_AES is  
port (	clk   : in std_logic;
		start : in std_logic;
		busy  : out std_logic;
        plaintext  : in std_logic_vector(127 downto 0);
		valid_o    : out std_logic;
        ciphertext_o : out std_logic_vector(127 downto 0);
		key        : out std_logic_vector(127 downto 0));
end entity;

architecture topArch of top_AES is
signal ciphertext : std_logic_vector(127 downto 0) :=(others => '0');
type KeysArray_t is array(0 to 10) of std_logic_vector(127 downto 0);
signal KeysArray : KeysArray_t := (
		x"2b7e151628aed2a6abf7158809cf4f3c",  -- Round 0
		x"a0fafe1788542cb123a339392a6c7605",  -- Round 1
		x"f2c295f27a96b9435935807a7359f67f",  -- Round 2
		x"3d80477d4716fe3e1e237e446d7a883b",  -- Round 3
		x"ef44a541a8525b7fb671253bdb0bad00",  -- Round 4
		x"d4d1c6f87c839d87caf2b8bc11f915bc",  -- Round 5
		x"6d88a37a110b3efddbf98641ca0093fd",  -- Round 6
		x"4e54f70e5f5fc9f384a64fb24ea6dc4f",  -- Round 7
		x"ead27321b58dbad2312bf5607f8d292f",  -- Round 8
		x"ac7766f319fadc2128d12941575c006e",  -- Round 9
		x"d014f9a8c9ee2589e13f0cc8b6630ca6"); -- Round 10
constant max_rounds : unsigned(3 downto 0) := x"A";
signal round    : unsigned(3 downto 0) :=(others => '0');
signal roundReg : unsigned(3 downto 0) :=(others => '0');

type state_t is (idle,round0 , subByteLayer , shiftRowsLayer , mixColumnLayer , keyAddLayer, finish );
signal current_state , next_state : state_t;


signal SubByte_in : std_logic_vector(127 downto 0);
signal SubByte_out : std_logic_vector(127 downto 0);

signal i_keyAddKey : std_logic_vector(127 downto 0);  
signal i_dataAddKey : std_logic_vector(127 downto 0); 
signal o_dataAddKey : std_logic_vector(127 downto 0); 

signal i_dataShiftRows : std_logic_vector(127 downto 0);
signal o_dataShiftRows : std_logic_vector(127 downto 0);

signal i_dataMixColumn : std_logic_vector(127 downto 0);
signal o_dataMixColumn : std_logic_vector(127 downto 0);


signal finished : std_logic :='0';

component subByte 
    port(
        data_in : in std_logic_vector(7 downto 0); --input data in GF(2^8)
        data_out : out std_logic_vector(7 downto 0)-- output data
   );
end component;
component shiftRows
    port (
        data_in_SR  : in  std_logic_vector(127 downto 0);
        data_out_SR : out std_logic_vector(127 downto 0)
    );
end component;

component Mixcolomun is 
    port (
        data_in_mx  : in  std_logic_vector(127 downto 0);
        data_out_mx : out std_logic_vector(127 downto 0)
    );
end component;

component addKey is 
    port ( data_in : in std_logic_vector(127 downto 0);
    key : in std_logic_vector(127 downto 0);
    data_out : out std_logic_vector(127 downto 0)
    );
end component;
begin 
	------------------------------------------------------
    --                 SubByte Layer                    --
    ------------------------------------------------------
    SubByte0 : SubByte port map (data_in => SubByte_in(127 downto 120), data_out => SubByte_out(127 downto 120));
    SubByte1 : SubByte port map (data_in => SubByte_in(119 downto 112), data_out => SubByte_out(119 downto 112));
    SubByte2 : SubByte port map (data_in => SubByte_in(111 downto 104), data_out => SubByte_out(111 downto 104));
    SubByte3 : SubByte port map (data_in => SubByte_in(103 downto 96),  data_out => SubByte_out(103 downto 96));
    SubByte4 : SubByte port map (data_in => SubByte_in(95 downto 88),   data_out => SubByte_out(95 downto 88));
    SubByte5 : SubByte port map (data_in => SubByte_in(87 downto 80),   data_out => SubByte_out(87 downto 80));
    SubByte6 : SubByte port map (data_in => SubByte_in(79 downto 72),   data_out => SubByte_out(79 downto 72));
    SubByte7 : SubByte port map (data_in => SubByte_in(71 downto 64),   data_out => SubByte_out(71 downto 64));
    SubByte8 : SubByte port map (data_in => SubByte_in(63 downto 56),   data_out => SubByte_out(63 downto 56));
    SubByte9 : SubByte port map (data_in => SubByte_in(55 downto 48),   data_out => SubByte_out(55 downto 48));
    SubByte10: SubByte port map (data_in => SubByte_in(47 downto 40),   data_out => SubByte_out(47 downto 40));
    SubByte11: SubByte port map (data_in => SubByte_in(39 downto 32),   data_out => SubByte_out(39 downto 32));
    SubByte12: SubByte port map (data_in => SubByte_in(31 downto 24),   data_out => SubByte_out(31 downto 24));
    SubByte13: SubByte port map (data_in => SubByte_in(23 downto 16),   data_out => SubByte_out(23 downto 16));
    SubByte14: SubByte port map (data_in => SubByte_in(15 downto 8),    data_out => SubByte_out(15 downto 8));
    SubByte15: SubByte port map (data_in => SubByte_in(7 downto 0),     data_out => SubByte_out(7 downto 0));
	------------------------------------------------------
    --                 ShiftRows Layer                  --
    ------------------------------------------------------
	shiftRowInst : shiftRows  
    port map ( data_in_SR => i_dataShiftRows, 
        data_out_SR => o_dataShiftRows
             );
	------------------------------------------------------
    --                MixColumn Layer                   --
    ------------------------------------------------------
	mixColumnInst : Mixcolomun 
    port map( data_in_mx => i_dataMixColumn ,
        data_out_mx => o_dataMixColumn
            );
	------------------------------------------------------
    --                 KeyAdd Layer                     --
    ------------------------------------------------------
	keyAddInst : addKey 
    port map ( key => i_keyAddKey, 
        data_in   => i_dataAddKey, 
        data_out   => o_dataAddKey
             );

	MEMORY_LOGIC : process(clk)
	               begin
				        if (rising_edge(clk)) then 
						    current_state <= next_state;
						end if;
				   end process;

	NEXT_STATE_LOGIC  : process(current_state , start ,round)
	                    begin
						case (current_state) is
				        when idle => 
                             if start = '1' then 
						        next_state <= round0;
							else 
							    next_state <= idle;
							end if;
						when round0 => 
                             next_state <= subByteLayer;
						when keyAddLayer => 
                             if (round < max_rounds) then --round < 10
						        next_state <= subByteLayer;
							 elsif (round = max_rounds) then
								next_state <= finish;
							 end if;
						when subByteLayer => 
                             next_state <= shiftRowsLayer;
						when shiftRowsLayer =>
                             if (round < max_rounds) then 
						        next_state <= mixColumnLayer;
							 else 
								next_state <= keyAddLayer;
							 end if;
						when mixColumnLayer => 
                             next_state <= keyAddLayer;
						when finish  => 
                             next_state <= idle;
						when others => 
                             null;
					    end case;
				  end process;
	OUTPUT_LOGIC : process (current_state )
	               begin
						finished <= '0';
				        case (current_state) is
				        when idle =>
                             round <= (others => '0');
						     busy <= '0';
							 valid_o <= '0';
						when round0 => 
                             i_keyAddKey  <= KeysArray(0);
                             i_dataAddKey <= plaintext;
                             busy <= '1'; 
                        when subByteLayer => 
						     if round < max_rounds then
                                round <= roundReg + to_unsigned(1,4);-- incremente le nombre de round 
								SubByte_in <= o_dataAddKey;
							 end if;
						when shiftRowsLayer =>
						     i_dataShiftRows <= SubByte_out;
						when mixColumnLayer =>
						     i_dataMixColumn <= o_dataShiftRows;
						when keyAddLayer =>
						     i_keyAddKey <= KeysArray(to_integer(round));
							 if round < max_rounds then
								i_dataAddKey <= o_dataMixColumn;
							 elsif round = max_rounds then 
							    i_dataAddKey <= o_dataShiftRows;
							  end if;
                        when finish =>
						     ciphertext <= o_dataAddKey;
							 valid_o <= '1';
							 busy <= '0';
							 finished <= '1';
				        when others => 
						     null;
				     end case;
				   end process;					
    ciphertext_o  <= ciphertext;
	key <= KeysArray(0);


	RoundRegister : process (clk) -- enregistrer le round pour  Éviter les conflits d’accès combinatoire
	begin
	     if (rising_edge(clk)) then 
		    roundReg <= round ;
	     end if;
	end process ;
end architecture;