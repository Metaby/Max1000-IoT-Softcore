-- Datei:	divider.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY divider IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_sgnd			:	in	std_logic;
		p_dividend	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_divisor		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_remain		:	out std_logic_vector(g_size DOWNTO 0);
		p_result		:	out std_logic_vector(g_size DOWNTO 0)
	);
  constant c_half_size : integer := ((g_size + 1) / 2) - 1;
END divider;

-- Entity Architektur
ARCHITECTURE arch OF divider IS
	-- Komponenten
	COMPONENT restoring_divider
		GENERIC (
			g_size : integer := 7
		);
		PORT (
			p_dividend	:	in std_logic_vector(g_size DOWNTO 0);
			p_divisor	:	in std_logic_vector(g_size DOWNTO 0);
			p_remain	:	out std_logic_vector(g_size DOWNTO 0);
			p_result		:	out std_logic_vector(g_size DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT absolute
		GENERIC (
			g_size 		: 	integer := 7
		);
		PORT (
			p_in		:	in std_logic_vector(g_size DOWNTO 0);
			p_out	:	out std_logic_vector(g_size DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT tc_converter
		GENERIC (
			g_size		:	integer := 7
		);
		PORT (
			p_in		:	in std_logic_vector(g_size DOWNTO 0);
			p_out	:	out std_logic_vector(g_size DOWNTO 0)
		);
	END COMPONENT;
	-- Signale
	SIGNAL s_exp_dividend		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_exp_divisor		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_abs_dividend		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_abs_divisor		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_usgnd_result		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_usgnd_remain		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_sgnd_result		:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_sgnd_remain		:	std_logic_vector(g_size + 1 DOWNTO 0);
	BEGIN
		s_exp_dividend	<= (p_sgnd and p_dividend(g_size)) & p_dividend;
		s_exp_divisor 	<= (p_sgnd and p_divisor(g_size)) & p_divisor;
		p_result     		<= s_usgnd_result(g_size DOWNTO 0) when (p_sgnd = '0' or (p_sgnd = '1' and not (p_dividend(g_size) xor p_divisor(g_size)) = '1')) else s_sgnd_result(g_size DOWNTO 0);
		p_remain  			<= s_usgnd_remain(g_size DOWNTO 0) when (p_sgnd = '0' or (p_sgnd = '1' and p_dividend(g_size) = '0')) else s_sgnd_remain(g_size DOWNTO 0);
		abs_dividend	:	absolute GENERIC MAP (g_size => g_size + 1) PORT MAP (s_exp_dividend, s_abs_dividend);
		abs_divisor		:	absolute GENERIC MAP (g_size => g_size + 1) PORT MAP (s_exp_divisor, s_abs_divisor);
		div						:	restoring_divider GENERIC MAP (g_size => g_size + 1) PORT MAP (s_abs_dividend, s_abs_divisor, s_usgnd_remain, s_usgnd_result);
		conv_res			:	tc_converter GENERIC MAP (g_size => g_size + 1) PORT MAP (s_usgnd_result, s_sgnd_result);
		conv_rem			:	tc_converter GENERIC MAP (g_size => g_size + 1) PORT MAP (s_usgnd_remain, s_sgnd_remain);
END arch;
