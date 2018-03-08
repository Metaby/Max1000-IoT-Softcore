-- Datei:	four_quadrant_multiplier.vhd
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
ENTITY four_quadrant_multiplier IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_sgnd			:	in 	std_logic;
		p_op_1			:	in	std_logic_vector(g_size DOWNTO 0);
		p_op_2			:	in 	std_logic_vector(g_size DOWNTO 0);
		p_add				:	in 	std_logic_vector(g_size DOWNTO 0);
		p_result_lo	:	out std_logic_vector(g_size DOWNTO 0);
		p_result_hi	:	out std_logic_vector(g_size DOWNTO 0)
	);
END four_quadrant_multiplier;

-- Entity Architektur
ARCHITECTURE arch OF four_quadrant_multiplier IS
	-- Komponenten
	COMPONENT multiplier_slice
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_sgnd		:	in std_logic;
		p_x_in		:	in std_logic;
		p_c_in		:	in std_logic;
		p_s_in		:	in std_logic_vector(g_size DOWNTO 0);
		p_a_in		:	in std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size + 1 DOWNTO 0)
	);
	END COMPONENT;
	-- Typ definitionen
	TYPE vector_map IS ARRAY(g_size DOWNTO 0) OF std_logic_vector(g_size + 1 DOWNTO 0);
	-- Signale
	SIGNAL s_wires : vector_map;
	SIGNAL s_sgnd_vector		: 	std_logic_vector(g_size DOWNTO 0);
BEGIN
	s_sgnd_vector <= (OTHERS => p_sgnd);
	gen_cra	:	FOR i IN 0 TO g_size GENERATE
	  SIGNAL a_s_in : std_logic_vector(g_size DOWNTO 0);
	  SIGNAL s_tc : std_logic;
	  BEGIN
		lsb	:	IF i = 0 GENERATE
	    a_s_in <= p_op_1;
			ms_0	:	multiplier_slice GENERIC MAP (g_size => g_size) PORT MAP (
			                                              p_sgnd,
																										p_op_2(i),
																										'0',
																										p_add,
																										a_s_in, -- (p_sgnd and ...) VZ-Expansion nur bei signed multiply
																										s_wires(i)
																									);
		END GENERATE lsb;
		bet	:	IF i > 0 and i < g_size GENERATE
		  a_s_in <= p_op_1;
			ms_i	:	multiplier_slice GENERIC MAP (g_size => g_size) PORT MAP (
			                                              p_sgnd,
																										p_op_2(i),
																										'0',
																										s_wires(i - 1)(g_size + 1 DOWNTO 1),
																										a_s_in, -- (p_sgnd and ...) VZ-Expansion nur bei signed multiply
																										s_wires(i)
																									);
		END GENERATE bet;
		msb	:	IF i = g_size GENERATE
		  a_s_in <= s_sgnd_vector xor p_op_1;
		  s_tc <= p_sgnd and p_op_2(i);
			ms_s	:	multiplier_slice GENERIC MAP (g_size => g_size) PORT MAP (
			                                              p_sgnd,
			                                              p_op_2(i),
																										s_tc, -- (p_sgnd and ...) msb von p_op_2 als cin (+1 im 2er komplement)
																										s_wires(i - 1)(g_size + 1 DOWNTO 1),
																										a_s_in, -- (p_sgnd and ...) VZ-Expansion nur bei signed multiply, (s_sgnd_vector xor) negation für 2er komplement
																										s_wires(i)
																									);
		END GENERATE msb;
		p_result_lo(i) <= s_wires(i)(0);
	END GENERATE gen_cra;
	p_result_hi <= s_wires(g_size)(g_size + 1 DOWNTO 1);
END arch;
