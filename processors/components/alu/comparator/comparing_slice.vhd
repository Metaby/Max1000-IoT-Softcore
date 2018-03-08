-- Datei:	comparing_slice.vhd
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
ENTITY comparing_slice IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1	:	in std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in std_logic_vector(g_size DOWNTO 0);
		p_g		:	out std_logic_vector((g_size + 1) / 2 - 1 DOWNTO 0);
		p_l		:	out std_logic_vector((g_size + 1) / 2 - 1 DOWNTO 0)
	);
END comparing_slice;

-- Entity Architektur
ARCHITECTURE arch OF comparing_slice IS
	-- Komponenten
	COMPONENT comparator PORT (
		p_x_0	:	in 	std_logic;
		p_y_0	:	in 	std_logic;
		p_x_1	:	in	std_logic;
		p_y_1	:	in	std_logic;
		p_g		:	out std_logic;
		p_l		:	out std_logic
	);
	END COMPONENT;
-- Verhalten
BEGIN
	gen_cs	:	FOR i IN 0 TO (g_size - 1) / 2 GENERATE
			comp_i	:	comparator PORT MAP(p_op_1(i * 2), p_op_2(i * 2), p_op_1(i * 2 + 1), p_op_2(i * 2 + 1), p_g(i), p_l(i));
	END GENERATE gen_cs;
END arch;
