-- Datei:	tree_comparator.vhd
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
USE ieee.math_real.all;

-- Entity Port und Generic
ENTITY tree_comparator IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in	std_logic_vector(g_size DOWNTO 0);
		p_sgnd	:	in 	std_logic;
		p_g			:	out std_logic;
		p_l			:	out std_logic
	);
  constant	c_log_size	:	integer := integer(log2(real(g_size + 1)));
END tree_comparator;

-- Entity Architektur
ARCHITECTURE arch OF tree_comparator IS
	-- Komponenten
	COMPONENT comparing_slice
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in	std_logic_vector(g_size DOWNTO 0);
		p_g			:	out std_logic_vector((g_size + 1) / 2 - 1 DOWNTO 0);
		p_l			:	out std_logic_vector((g_size + 1) / 2 - 1 DOWNTO 0)
	);
	END COMPONENT;
	-- Typ definitionen
	TYPE vector_map IS ARRAY(g_size DOWNTO 0) OF std_logic_vector(g_size DOWNTO 0);
	-- Signale
	SIGNAL s_wires_g  : vector_map;
	SIGNAL s_wires_l  : vector_map;
	SIGNAL s_result		:	std_logic_vector(1 DOWNTO 0);
-- Verhalten
BEGIN
	gen_tc	:	FOR i IN 0 TO c_log_size - 1 GENERATE
	  CONSTANT c_current_upper_bound : integer := (g_size + 1) / (2**(i + 1)) - 1;
	  CONSTANT c_last_upper_bound    : integer := (g_size + 1) / (2**i) - 1;
	  BEGIN
		first_stage	:	IF i = 0 GENERATE
			cs_0	:	comparing_slice GENERIC MAP (g_size => g_size) PORT MAP (
																																			p_op_1,
																																			p_op_2,
																																			s_wires_g(i)(c_current_upper_bound DOWNTO 0),
																																			s_wires_l(i)(c_current_upper_bound DOWNTO 0)

																																		);
		END GENERATE first_stage;
		mid_stage	:	IF i > 0 and i < c_log_size - 1 GENERATE
			cs_i	:	comparing_slice GENERIC MAP (g_size => (g_size + 1) / 2**i - 1) PORT MAP	(
			                                                                                  s_wires_g(i - 1)(c_last_upper_bound DOWNTO 0),
			                                                                                  s_wires_l(i - 1)(c_last_upper_bound DOWNTO 0),	
			                                                                                  s_wires_g(i)(c_current_upper_bound DOWNTO 0),
																																			                  s_wires_l(i)(c_current_upper_bound DOWNTO 0)
																																										 	);
		END GENERATE mid_stage;
		last_stage	:	IF i = c_log_size - 1 GENERATE
			cs_s	:	comparing_slice GENERIC MAP (g_size => 1) PORT MAP	(
			                                                            s_wires_g(i - 1)(c_last_upper_bound DOWNTO 0),
			                                                            s_wires_l(i - 1)(c_last_upper_bound DOWNTO 0),	
																																	s_result(1 DOWNTO 1),
																																	s_result(0 DOWNTO 0)
																																);
		END GENERATE last_stage;
	END GENERATE gen_tc;
	p_g <= (s_result(1) and not p_sgnd) or (p_sgnd and not p_op_1(g_size) and p_op_2(g_size)) or (p_sgnd and not (p_op_1(g_size) xor p_op_2(g_size)) and s_result(1));
	p_l <= (s_result(0) and not p_sgnd) or (p_sgnd and p_op_1(g_size) and not p_op_2(g_size)) or (p_sgnd and not (p_op_1(g_size) xor p_op_2(g_size)) and s_result(0));
END arch;
