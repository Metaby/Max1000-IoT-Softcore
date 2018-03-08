-- Datei:	multiplier_slice.vhd
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
ENTITY multiplier_slice IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_sgnd		:	in 	std_logic;
		p_x_in		:	in	std_logic;
		p_c_in		:	in 	std_logic;
		p_s_in		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_a_in		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size + 1 DOWNTO 0)
	);
END multiplier_slice;

-- Entity Architektur
ARCHITECTURE arch OF multiplier_slice IS
	-- Komponenten
	COMPONENT multiplier_base_cell
	PORT (
		p_s_in	:	in	std_logic;
		p_a_in	:	in	std_logic;
		p_x_in	:	in	std_logic;
		p_c_in	:	in	std_logic;
		p_s_out	:	out std_logic;
		p_c_out	:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL s_wires	:	std_logic_vector(g_size + 1 DOWNTO 0);
	SIGNAL s_msb_out	:	std_logic;
BEGIN
	gen_cra	:	FOR i IN 0 TO g_size + 1 GENERATE
		lsb	:	IF i = 0 GENERATE
			mbc0	:	multiplier_base_cell PORT MAP(p_s_in(i), p_a_in(i), p_x_in, p_c_in, p_result(i), s_wires(i));
		END GENERATE lsb;
		bet	:	IF i > 0 and i < g_size + 1 GENERATE
			mbci	:	multiplier_base_cell PORT MAP(p_s_in(i), p_a_in(i), p_x_in, s_wires(i - 1), p_result(i), s_wires(i));
		END GENERATE bet;
		msb	:	IF i = g_size + 1 GENERATE
			mbcs	:	multiplier_base_cell PORT MAP(p_s_in(i - 1), p_a_in(i - 1), p_x_in, s_wires(i - 1), s_msb_out, s_wires(i));
		END GENERATE msb;
	END GENERATE gen_cra;
	p_result(g_size + 1) <= (p_sgnd and s_msb_out) or (not p_sgnd and s_wires(g_size));
END arch;
