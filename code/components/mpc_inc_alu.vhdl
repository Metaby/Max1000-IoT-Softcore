-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mpc_inc_alu IS
  GENERIC (
    g_word_size : integer := 15
  );
  PORT (
    p_input_A0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_input_B0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_flag : out std_logic;
    p_output_1 : out std_logic_vector(g_word_size DOWNTO 0);
    p_output_2 : out std_logic_vector(g_word_size DOWNTO 0)
  );
END mpc_inc_alu;

ARCHITECTURE behavior OF mpc_inc_alu IS
  COMPONENT carry_select_adder
    GENERIC (
      g_block_size : integer := 7;
      g_blocks     : integer := 3
    );
    PORT (
      p_sgnd   : in  std_logic;
      p_sub    : in  std_logic;
      p_op_1   : in  std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
      p_op_2   : in  std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
      p_result : out std_logic_vector((g_block_size + 1) * (g_blocks + 1) - 1 DOWNTO 0);
      p_ovflw  : out std_logic
    );
  END COMPONENT;
  SIGNAL s_input_A : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_input_B : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_sgnd : std_logic;
  SIGNAL s_adder_sub : std_logic;
  SIGNAL s_adder_ovflw : std_logic;
  SIGNAL s_adder_result : std_logic_vector(g_word_size DOWNTO 0);
BEGIN
  -- Control Vector Binding
  -- Input A Multiplexing
  s_input_A <= p_input_A0;
  -- Input B Multiplexing
  s_input_B <= p_input_B0;
  -- Instances of Sub-Components
  adder : carry_select_adder GENERIC MAP (g_block_size => 7, g_blocks => 1) PORT MAP (s_sgnd, s_adder_sub, s_input_A, s_input_B, s_adder_result, s_adder_ovflw);
  -- Output Multiplexers
  p_output_1 <= s_adder_result;
  p_flag <= s_adder_ovflw;
  -- Command Tables
  s_sgnd <= '0';
  s_adder_sub <= '0';

END behavior;