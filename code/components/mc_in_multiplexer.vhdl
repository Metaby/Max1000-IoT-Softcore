-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mc_in_multiplexer IS
  GENERIC (
    g_word_size : integer := 23
  );
  PORT (
    p_input0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_word : out std_logic_vector(g_word_size DOWNTO 0)
  );
END mc_in_multiplexer;

ARCHITECTURE behavior OF mc_in_multiplexer IS
BEGIN
  p_word <= p_input0;

END behavior;