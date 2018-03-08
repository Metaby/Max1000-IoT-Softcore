-- Datei:	carry_select_block.vhd
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
ENTITY carry_select_block IS
	GENERIC (
		g_size 	:	integer := 3
	);
	PORT (
		p_c_in	:	in std_logic;
		p_op_1	:	in std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0);
		p_c_out	:	out std_logic
	);
END carry_select_block;

-- Entity Architektur
ARCHITECTURE arch OF carry_select_block IS
	-- Komponenten
	COMPONENT carry_ripple_adder
   GENERIC (
		g_size : integer := g_size
	);
	PORT (
		p_c_in	:	in	std_logic;
		p_op_1	:	in std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0);
		p_c_out	:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL s_c_0_result	:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_c_1_result	:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_result			:	std_logic_vector(g_size + 1 DOWNTO 0);
	BEGIN
		c_0_cra	:	carry_ripple_adder GENERIC MAP (g_size => g_size) PORT MAP (
																									'0',
																									p_op_1(g_size DOWNTO 0),
																									p_op_2(g_size DOWNTO 0),
																									s_c_0_result(g_size DOWNTO 0),
																									s_c_0_result(g_size + 1)
																								);
		c_1_cra	:	carry_ripple_adder GENERIC MAP (g_size => g_size) PORT MAP (
																									'1',
																									p_op_1(g_size DOWNTO 0),
																									p_op_2(g_size DOWNTO 0),
																									s_c_1_result(g_size DOWNTO 0),
																									s_c_1_result(g_size + 1)
																								);
		p_result <= s_c_0_result(g_size DOWNTO 0) when (p_c_in = '0')
								else s_c_1_result(g_size DOWNTO 0);
		p_c_out	 <= s_c_0_result(g_size + 1) when (p_c_in = '0')
								else s_c_1_result(g_size + 1);
END arch;
