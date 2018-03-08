-- Datei:	divider_slice.vhd
-- Autor:	Max Brand
-- Datum: 14.07.2016

-- Pakete
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Port und Generic
ENTITY divider_slice IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_m_in			:	in	std_logic := '0';
		p_dividend	:	in 	std_logic_vector(g_size DOWNTO 0);
		p_divisor		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_c_out			:	out std_logic;
		p_remain		:	out std_logic_vector(g_size DOWNTO 0)
	);
END divider_slice;

-- Entity Architektur
ARCHITECTURE arch OF divider_slice IS
	-- Komponenten
	COMPONENT carry_ripple_adder
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_c_in		:	in	std_logic;
		p_op_1		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_op_2		:	in 	std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0);
		p_c_out		:	out std_logic
	);
	END COMPONENT;
	-- Signale
	SIGNAL s_wires		:	std_logic_vector(g_size DOWNTO 0) := (OTHERS => '0');
	SIGNAL s_carry	:	std_logic := '0';
	SIGNAL s_inv_divisor : std_logic_vector(g_size DOWNTO 0) := (OTHERS => '0');
BEGIN
  s_inv_divisor <= not p_divisor;
	cra	:	carry_ripple_adder GENERIC MAP (g_size => g_size) PORT MAP ('1', p_dividend, s_inv_divisor, s_wires, s_carry);
	p_remain <= s_wires when (p_m_in = '0')
							else p_dividend;
	p_c_out <= not s_carry;
END arch;
