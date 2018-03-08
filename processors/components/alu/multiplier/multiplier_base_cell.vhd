-- Datei:	multiplier_base_cell.vhd
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
ENTITY multiplier_base_cell IS
	PORT (
		p_s_in	:	in	std_logic;
		p_a_in	:	in	std_logic;
		p_x_in	:	in	std_logic;
		p_c_in	:	in	std_logic;
		p_s_out	:	out std_logic;
		p_c_out	:	out std_logic
	);
END multiplier_base_cell;

-- Entity Architektur
ARCHITECTURE arch OF multiplier_base_cell IS
	-- Komponenten
	COMPONENT full_adder PORT (
			p_x			:	in std_logic;
			p_y			:	in std_logic;
			p_c_in	:	in std_logic;
			p_s			:	out std_logic;
			p_c_out	:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL s_a_and_x : std_logic;
BEGIN
  s_a_and_x <= p_a_in and p_x_in;
	fa	:	full_adder PORT MAP(p_s_in, s_a_and_x, p_c_in, p_s_out, p_c_out);
END arch;
