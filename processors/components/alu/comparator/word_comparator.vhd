-- Datei:	word_comparator.vhd
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
USE ieee.math_real.all;

-- Entity Port und Generic
ENTITY word_comparator IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_op_2		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_cmd			:	in 	std_logic_vector(2 DOWNTO 0);
		p_sgnd		:	in 	std_logic;
		p_result	:	out std_logic
	);
END word_comparator;

-- Entity Architektur
ARCHITECTURE arch OF word_comparator IS
	-- Komponenten
	COMPONENT tree_comparator
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_op_1	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_op_2	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_sgnd	:	in 	std_logic;
		p_g			:	out std_logic;
		p_l			:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL	s_g	: std_logic;
	SIGNAL	s_l	: std_logic;
-- Verhalten
BEGIN
	tc	:	tree_comparator GENERIC MAP (g_size => g_size) PORT MAP (p_op_1, p_op_2, p_sgnd, s_g, s_l);
	p_result <= (not p_cmd(2) and not p_cmd(1) and not p_cmd(0) and s_g and not s_l) or		-- a > b
							(not p_cmd(2) and not p_cmd(1) and p_cmd(0) and not s_g and s_l) or				-- a < b
							(not p_cmd(2) and p_cmd(1) and not p_cmd(0) and not s_l) or								-- a >= b
							(not p_cmd(2) and p_cmd(1) and p_cmd(0) and not s_g) or										-- a <= b
							(p_cmd(2) and not p_cmd(1) and not p_cmd(0) and not s_g and not s_l);			-- a = b
END arch;
