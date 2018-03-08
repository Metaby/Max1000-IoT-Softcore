-- Datei:	full_adder.vhd
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
ENTITY full_adder IS
	PORT (
		p_x			:	in std_logic;
		p_y			:	in std_logic;
		p_c_in	:	in std_logic;
		p_s			:	out std_logic;
		p_c_out	:	out std_logic
	);
END full_adder;

-- Entity Architektur
ARCHITECTURE arch OF full_adder IS
	-- Komponenten
	COMPONENT half_adder PORT (
		p_x	:	in std_logic;
		p_y	:	in std_logic;
		p_s	:	out std_logic;
		p_c	:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL s_sum_1	: std_logic;
	SIGNAL s_c_1		: std_logic;
	SIGNAL s_c_2		: std_logic;
BEGIN
	ha1	:	half_adder PORT MAP(p_x, p_y, s_sum_1, s_c_1);
	ha2	:	half_adder PORT MAP(s_sum_1, p_c_in, p_s, s_c_2);
	p_c_out <= s_c_1 or s_c_2;
END arch;

