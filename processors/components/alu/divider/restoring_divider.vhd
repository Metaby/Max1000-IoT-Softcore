-- Datei:	restoring_divider.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY restoring_divider IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_dividend	:	in  std_logic_vector(g_size DOWNTO 0);
		p_divisor		:	in  std_logic_vector(g_size DOWNTO 0);
		p_remain		:	out std_logic_vector(g_size DOWNTO 0);
		p_result		:	out std_logic_vector(g_size DOWNTO 0)
	);
  constant c_half_size : integer := ((g_size + 1) / 2) - 1;
END restoring_divider;

-- Entity Architektur
ARCHITECTURE arch OF restoring_divider IS
-- Komponenten
COMPONENT divider_slice
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_m_in	:	in	std_logic;
		p_dividend	:	in std_logic_vector(g_size DOWNTO 0);
		p_divisor	:	in std_logic_vector(g_size DOWNTO 0);
		p_c_out		:	out std_logic;
		p_remain	:	out std_logic_vector(g_size DOWNTO 0)
	);
	END COMPONENT;
	-- Typ definitionen
	TYPE vector_map IS ARRAY(g_size DOWNTO 0) OF std_logic_vector(g_size DOWNTO 0);
	-- Signale
	SIGNAL s_zero_vector	:	std_logic_vector(g_size DOWNTO 0) := (others => '0');
	SIGNAL s_carries	:	std_logic_vector(g_size DOWNTO 0) := (others => '0');
	SIGNAL s_wires	:	vector_map;
	SIGNAL s_shifted_dividend : vector_map;
BEGIN
	gen_d	:	FOR i IN 0 TO g_size GENERATE
		lsb	:	IF i = 0 GENERATE
		  s_shifted_dividend(i) <= s_zero_vector(g_size -  1 DOWNTO 0) & p_dividend(g_size);
			ds_0	:	divider_slice GENERIC MAP (g_size => g_size) PORT MAP(s_carries(i), s_shifted_dividend(i), p_divisor, s_carries(i), s_wires(i));
			p_result(g_size) <= not s_carries(i);
		END GENERATE lsb;
		msbs	:	IF i > 0 GENERATE
		  s_shifted_dividend(i) <= s_wires(i - 1)(g_size - 1 DOWNTO 0) & p_dividend(g_size - i);
			ds_i	:	divider_slice GENERIC MAP (g_size => g_size) PORT MAP(s_carries(i), s_shifted_dividend(i), p_divisor, s_carries(i), s_wires(i));
			p_result(g_size - i) <= not s_carries(i);
		END GENERATE msbs;
 	END GENERATE gen_d;
	p_remain <= s_wires(g_size);
END arch;
