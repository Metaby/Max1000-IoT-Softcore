-- Datei:	absolute.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY absolute IS
	GENERIC (
		g_size 		: 	integer := 7
	);
	PORT (
		p_in	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_out	:	out std_logic_vector(g_size DOWNTO 0)
	);
END absolute;

-- Entity Architektur
ARCHITECTURE arch OF absolute IS
-- DELETE
--COMPONENT gen_mux
--GENERIC (
--	g_size	:	integer := 7
--);
--PORT (
--	sel	:	in std_logic;
--	op1	:	in std_logic_vector(g_size DOWNTO 0);
--	op2	:	in std_logic_vector(g_size DOWNTO 0);
--	res	:	out std_logic_vector(g_size DOWNTO 0)
--);
--END COMPONENT;
	-- Komponenten
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
	SIGNAL s_wires	:	std_logic_vector(g_size DOWNTO 0);
BEGIN
	tcc	:	tc_converter GENERIC MAP (g_size => g_size) PORT MAP(p_in, s_wires);
	p_out <=	p_in when (p_in(g_size) = '0')
						else s_wires;
	-- DELETE
	--mux	:	gen_mux GENERIC MAP (g_size => g_size) PORT MAP (p_in(g_size), p_in, s_wires, p_out);
END arch;
