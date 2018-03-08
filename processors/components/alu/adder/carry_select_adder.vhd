-- Datei:	carry_select_adder.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Code-Konventionen
-- Variablenbenennung
-- g_<name> entspricht Generic
-- p_<name> entspricht Port
-- c_<name> entspricht Konstante
-- s_<name> entspricht Signal

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY carry_select_adder IS
	GENERIC (
		g_block_size 	:	integer := 3;
		g_blocks		:	integer := 1
	);
	PORT (
		p_sgnd		:	in	 std_logic;
		p_sub			:	in  std_logic;
		p_op_1		:	in  std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
		p_op_2		:	in  std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
		p_result		:	out std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
		p_ovflw		:	out std_logic
	);
END carry_select_adder;

-- Entity Architektur
ARCHITECTURE arch OF carry_select_adder IS
	-- Komponenten
	COMPONENT carry_select_block
	GENERIC (
		g_size 	:	integer := 3
	);
	PORT (
		p_c_in		:	in  std_logic;
		p_op_1		:	in  std_logic_vector(g_size DOWNTO 0);
		p_op_2		:	in  std_logic_vector(g_size DOWNTO 0);
		p_result		:	out std_logic_vector(g_size DOWNTO 0);
		p_c_out		:	out std_logic
	);
	END COMPONENT;
	-- Signale
	CONSTANT msb : integer := (g_block_size + 1) * (g_blocks + 1) - 1;
	SIGNAL s_carries		:	std_logic_vector(g_blocks DOWNTO 0);
	SIGNAL s_sub_vector	:	std_logic_vector(g_block_size DOWNTO 0);
	SIGNAL s_result  : std_logic_vector(msb DOWNTO 0);
BEGIN
	s_sub_vector <= (OTHERS => p_sub);
	gen_csa	:	FOR i IN 0 TO g_blocks GENERATE
	SIGNAL s_inv_op : std_logic_vector(g_block_size DOWNTO 0);
	  CONSTANT c_lower_bound : integer := (g_block_size + 1) * i;
	  CONSTANT c_upper_bound : integer := (g_block_size + 1) * i + g_block_size;
	  BEGIN
		lsb	:	IF i = 0 GENERATE
		  s_inv_op <= s_sub_vector xor p_op_2(c_upper_bound DOWNTO c_lower_bound);
			csb0	:	carry_select_block GENERIC MAP (g_size => g_block_size) PORT MAP (
														p_sub,
														p_op_1(c_upper_bound DOWNTO c_lower_bound),
														s_inv_op,
														s_result(c_upper_bound DOWNTO c_lower_bound),
														s_carries(i)
													);
		END GENERATE lsb;
		msbs	:	IF i > 0 GENERATE
		  s_inv_op <= s_sub_vector xor p_op_2(c_upper_bound DOWNTO c_lower_bound);
			csbi	:	carry_select_block GENERIC MAP (g_size => g_block_size) PORT MAP (
														s_carries(i - 1),
														p_op_1(c_upper_bound DOWNTO c_lower_bound),
														s_inv_op,
														s_result(c_upper_bound DOWNTO c_lower_bound),
														s_carries(i)
													);
		END GENERATE msbs;
	END GENERATE gen_csa;
	p_ovflw <=  (p_op_1(msb) and p_op_2(msb) and not s_result(msb)) or 
					(not p_op_1(msb) and not p_op_2(msb) and s_result(msb))
					when p_sgnd = '1' else s_carries(g_blocks);
	p_result <= s_result;
END arch;
