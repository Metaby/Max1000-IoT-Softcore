-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY m2_multiplexer IS
  GENERIC (
    g_word_size : integer := 15
  );
  PORT (
    p_input0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_input1 : in std_logic_vector(g_word_size DOWNTO 0);
    p_isel : in std_logic;
    p_word : out std_logic_vector(g_word_size DOWNTO 0)
  );
END m2_multiplexer;

ARCHITECTURE behavior OF m2_multiplexer IS
BEGIN
  WITH p_isel SELECT p_word <=
    p_input0 WHEN '0',
    p_input1 WHEN '1',
    (OTHERS => '0') WHEN OTHERS;

END behavior;