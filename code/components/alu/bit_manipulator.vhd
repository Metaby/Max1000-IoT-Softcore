LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.math_real.all;

ENTITY bit_manipulator IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1	:	in std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in std_logic_vector(g_size DOWNTO 0);
		p_cmd		:	in std_logic_vector(1 DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0)
	);
END bit_manipulator;

ARCHITECTURE arch OF bit_manipulator IS
BEGIN
	WITH p_cmd SELECT
		p_result <= 	p_op_1 and 	p_op_2	WHEN "00",
					p_op_1 or 	p_op_2 	WHEN "01",
					p_op_1 xor 	p_op_2 	WHEN "10",
					not p_op_1				WHEN "11",
					(others => '0') WHEN others;
END arch;