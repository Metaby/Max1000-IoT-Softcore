-- Datei:	barrel_shifter.vhd
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
ENTITY barrel_shifter IS
	GENERIC (
		g_size : integer := 7
	);
	PORT (
		p_cmd	    :	in	std_logic_vector(1 DOWNTO 0);
		p_arith	  :	in	std_logic;
		p_rotate	:	in  std_logic;
		p_op_1	  :	in  std_logic_vector(g_size DOWNTO 0);
		p_op_2	  :	in  std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0)
	);
   constant p_log_size : integer := integer(log2(real(g_size + 1)));
END barrel_shifter;

-- Entity Architektur
ARCHITECTURE arch OF barrel_shifter IS
  -- Komponenten
	COMPONENT shifting_slice
	GENERIC (
		g_size : integer := 7;
		g_step : integer := 1
	);
	PORT (
		p_arith	  :	in	std_logic;
		p_rotate  :	in  std_logic;
		p_ctrl	  :	in	std_logic_vector(1 DOWNTO 0);
		p_op		  :	in  std_logic_vector(g_size DOWNTO 0);
		p_result	:	out std_logic_vector(g_size DOWNTO 0)
	);
	END COMPONENT;
  -- Typ definitionen
	TYPE vector_map_2 IS ARRAY (g_size DOWNTO 0) OF std_logic_vector(1 DOWNTO 0);
	TYPE vector_map_n IS ARRAY (g_size DOWNTO 0) OF std_logic_vector(g_size DOWNTO 0);
  -- Signale
	SIGNAL s_wires	:	vector_map_n; --std_logic_vector((g_size + 1) * (g_size + 1) - 1 DOWNTO 0);
	SIGNAL s_ctrl : vector_map_2;
BEGIN
	gen_bs	:	FOR i IN 0 TO p_log_size - 1 GENERATE
		s_ctrl(i) <= (p_cmd(1) and p_op_2(i)) & (p_cmd(0) and p_op_2(i));
		lsb 	:	IF i = 0 GENERATE
			ss_0	:	shifting_slice GENERIC MAP (g_size => g_size, g_step => (i + 1)) PORT MAP	(
                                                                                        p_arith,
																														                            p_rotate,
																														                            s_ctrl(i),
																														                            p_op_1,
																														                            s_wires(i)
                                                                                      );
		END GENERATE lsb;
		bet	:	IF i > 0 and i < p_log_size - 1 GENERATE
			ss_i	:	shifting_slice GENERIC MAP (g_size => g_size, g_step => (i + 1)) PORT MAP	(
                                                                                        p_arith,
																														                            p_rotate,
																														                            s_ctrl(i),
																														                            s_wires(i - 1),
																														                            s_wires(i)
                                                                                      );
		END GENERATE bet;
		msb	:	IF i = p_log_size - 1 GENERATE
			ss_s	:	shifting_slice GENERIC MAP (g_size => g_size, g_step => (i + 1)) PORT MAP	(
                                                                                          p_arith,
																														                              p_rotate,
																														                              s_ctrl(i),
																														                              s_wires(i - 1),
																														                              p_result
                                                                                        );
		END GENERATE msb;
	END GENERATE gen_bs;
END arch;
