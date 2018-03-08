-- Datei:	shifting_slice.vhd
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
ENTITY shifting_slice IS
	GENERIC (
		g_size : integer := 7;
		g_step : integer := 1
	);
	PORT (
		p_arith	:	in	std_logic;
		p_rotate	:	in std_logic;
		p_ctrl	:	in	std_logic_vector(1 DOWNTO 0);
		p_op		:	in std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0)
	);
END shifting_slice;

-- Entity Architektur
ARCHITECTURE arch OF shifting_slice IS
	-- Signale
	SIGNAL s_wires	:	std_logic_vector(((g_size + 1) * 4) - 1 DOWNTO 0);
BEGIN
	gen_ss	:	FOR i IN 0 TO g_size GENERATE
		s_wires(i * 4 + 0) <= p_op(i);
		case_1	:	IF (i < 2**(g_step - 1)) GENERATE
								s_wires(i * 4 + 1) <= p_rotate and p_op(g_size - 2**(g_step - 1) + i + 1);
							END GENERATE case_1;
		case_2  : IF (i >= 2**(g_step - 1)) GENERATE
								s_wires(i * 4 + 1) <= p_op(i - 2**(g_step - 1));
							END GENERATE case_2;
		case_3	:	IF (i > g_size - 2**(g_step - 1)) GENERATE
								s_wires(i * 4 + 2) <= (p_arith and not p_rotate and p_op(g_size)) or (not p_arith and p_rotate and p_op(i - g_size + 2**(g_step - 1) - 1));
							END GENERATE case_3;
		case_4  : IF (i <= g_size - 2**(g_step - 1)) GENERATE
								s_wires(i * 4 + 2) <= p_op(i + 2**(g_step - 1));
							END GENERATE case_4;
		s_wires(i * 4 + 3) <= '0';
		-- 4 aus 1 Selektor
		p_result(i) <=  s_wires(i * 4)      when p_ctrl = "00" else
		                s_wires(i * 4 + 1)  when p_ctrl = "01" else
		                s_wires(i * 4 + 2)  when p_ctrl = "10" else
		                s_wires(i * 4 + 3);
         			
	END GENERATE gen_ss;
END arch;
