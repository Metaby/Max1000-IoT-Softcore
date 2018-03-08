LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY divider IS
	GENERIC (
		size : integer := 7
	);
	PORT (
		dividend	:	in std_logic_vector(size DOWNTO 0);
		divisor	:	in std_logic_vector(size DOWNTO 0);
		remain	:	out std_logic_vector(size DOWNTO 0);
		res		:	out std_logic_vector(size DOWNTO 0)
	);
  constant half_size : integer := ((size + 1) / 2) - 1;
END divider;

ARCHITECTURE arch OF divider IS
COMPONENT divider_slice
	GENERIC (
		size : integer := 7
	);
	PORT (
		m_in	:	in	std_logic;
		dividend	:	in std_logic_vector(size DOWNTO 0);
		divisor	:	in std_logic_vector(size DOWNTO 0);
		c_out		:	out std_logic;
		remain	:	out std_logic_vector(size DOWNTO 0)
	);
	END COMPONENT;	
	TYPE vector_map IS ARRAY(size DOWNTO 0) OF std_logic_vector(size DOWNTO 0);
	SIGNAL zeros	:	std_logic_vector(size DOWNTO 0) := (others => '0');
	SIGNAL carries	:	std_logic_vector(size DOWNTO 0) := (others => '0');
	SIGNAL con	:	vector_map;
	SIGNAL tmp : vector_map;
BEGIN
	gen_d	:	FOR i IN 0 TO size GENERATE
		lsb	:	IF i = 0 GENERATE
		  tmp(i) <= zeros(size -  1 DOWNTO 0) & dividend(size); 
			ds0	:	divider_slice GENERIC MAP (size => size) PORT MAP(carries(i), tmp(i), divisor, carries(i), con(i));
			res(size) <= not carries(i);
		END GENERATE lsb;
		msbs	:	IF i > 0 GENERATE
		  tmp(i) <= con(i - 1)(size - 1 DOWNTO 0) & dividend(size - i);
			dsi	:	divider_slice GENERIC MAP (size => size) PORT MAP(carries(i), tmp(i), divisor, carries(i), con(i));
			res(size - i) <= not carries(i);
		END GENERATE msbs;
 	END GENERATE gen_d;
	remain <= con(size);
END arch;