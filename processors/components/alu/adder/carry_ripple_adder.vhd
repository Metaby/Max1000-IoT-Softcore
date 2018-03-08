-- Datei:	carry_ripple_adder.vhd
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
ENTITY carry_ripple_adder IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_c_in		:	in	std_logic;
		p_op_2		:	in  std_logic_vector(g_size DOWNTO 0);
		p_op_1		:	in  std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0);
		p_c_out		:	out std_logic
	);
END carry_ripple_adder;

-- Entity Architektur
ARCHITECTURE arch OF carry_ripple_adder IS
	-- Komponenten
	COMPONENT full_adder
		PORT (
			p_x			:	in std_logic;
			p_y			:	in std_logic;
			p_c_in	:	in std_logic;
			p_s			:	out std_logic;
			p_c_out	:	out std_logic
		);
	END COMPONENT;
	-- Signale
	SIGNAL s_carries	:	std_logic_vector(g_size DOWNTO 0);
BEGIN
	cra	:	FOR i IN 0 TO g_size GENERATE
		lsb	:	IF i = 0 GENERATE
			fa_0	:	full_adder PORT MAP(p_op_1(0), p_op_2(0), p_c_in, p_result(0), s_carries(0));
		END GENERATE lsb;
		msbs	:	IF i > 0 GENERATE
			fa_i	:	full_adder PORT MAP(p_op_1(i), p_op_2(i), s_carries(i - 1), p_result(i), s_carries(i));
		END GENERATE msbs;
	END GENERATE cra;
	p_c_out	<= s_carries(g_size);
END arch;
