-- Datei:	comparator.vhd
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

-- Entity Port
ENTITY comparator IS
	PORT (
		p_x_0	:	in 	std_logic;
		p_y_0	:	in 	std_logic;
		p_x_1	:	in	std_logic;
		p_y_1	:	in	std_logic;
		p_g		:	out std_logic;
		p_l		:	out std_logic
	);
END comparator;

-- Entity Architektur
ARCHITECTURE arch OF comparator IS
-- Verhalten
BEGIN
	p_g <= (p_x_1 and not p_y_1) or (p_x_1 and p_x_0 and not p_y_0) or (not p_y_1 and p_x_0 and not p_y_0);
	p_l <= (not p_x_1 and p_y_1) or (not p_x_1 and not p_x_0 and p_y_0) or (p_y_1 and not p_x_0 and p_y_0);
END arch;
