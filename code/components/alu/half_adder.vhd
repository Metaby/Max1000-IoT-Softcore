-- Datei:	half_adder.vhd
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
ENTITY half_adder IS
	PORT (
		p_x	:	in std_logic;
		p_y	:	in std_logic;
		p_s	:	out std_logic;
		p_c	:	out std_logic
	);
END half_adder;

-- Entity Architektur
ARCHITECTURE arch OF half_adder IS
BEGIN
	p_s <= p_x xor p_y;
	p_c <= p_x and p_y;
END arch;
