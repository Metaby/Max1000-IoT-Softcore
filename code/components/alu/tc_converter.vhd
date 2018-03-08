-- Datei:	tc_converter.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY tc_converter IS
	GENERIC (
		g_size		:	integer := 7
	);
	PORT (
		p_in	:	in  std_logic_vector(g_size DOWNTO 0);
		p_out	:	out std_logic_vector(g_size DOWNTO 0)
	);
END tc_converter;

-- Entity Architektur
ARCHITECTURE arch OF tc_converter IS
-- Signale
SIGNAL	s_wires		:		std_logic_vector(g_size DOWNTO 0);
BEGIN
	gen_tcc	:	FOR i IN 0 TO g_size GENERATE
		lsb	:	IF i = 0 GENERATE
			s_wires(i) <= p_in(i);
			p_out(i) <= p_in(i);
		END GENERATE lsb;
		msbs	:	IF i > 0 GENERATE
			s_wires(i) <= s_wires(i - 1) or p_in(i);
			p_out(i) <= p_in(i) xor s_wires(i - 1);
		END GENERATE msbs;
 	END GENERATE gen_tcc;
END arch;
