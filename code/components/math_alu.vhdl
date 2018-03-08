-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY math_alu IS
  GENERIC (
    g_word_size : integer := 7
  );
  PORT (
    p_input_A0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_input_B0 : in std_logic_vector(g_word_size DOWNTO 0);
    p_ctrl : in std_logic_vector(4 DOWNTO 0);
    p_flag : out std_logic;
    p_output_1 : out std_logic_vector(g_word_size DOWNTO 0);
    p_output_2 : out std_logic_vector(g_word_size DOWNTO 0)
  );
END math_alu;

ARCHITECTURE behavior OF math_alu IS
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
  COMPONENT bit_manipulator
    GENERIC (
      g_size : integer := 31
    );
    PORT (
      p_op_1   : in  std_logic_vector(g_size DOWNTO 0);
      p_op_2   : in  std_logic_vector(g_size DOWNTO 0);
      p_cmd    : in  std_logic_vector(1 DOWNTO 0);
      p_result : out std_logic_vector(g_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT word_comparator 
    GENERIC (
      g_size : integer := 31
    );
    PORT (
      p_op_1   : in  std_logic_vector(g_size DOWNTO 0);
      p_op_2   : in  std_logic_vector(g_size DOWNTO 0);
		p_cmd    : in  std_logic_vector(2 DOWNTO 0);
      p_sgnd   : in  std_logic;
      p_result : out std_logic
    );
  END COMPONENT;
  COMPONENT divider 
    GENERIC (
      g_size : integer := 31
    );
    PORT (
      p_sgnd     : in  std_logic;
      p_dividend : in  std_logic_vector(g_size DOWNTO 0);
      p_divisor  : in  std_logic_vector(g_size DOWNTO 0);
      p_remain   : out std_logic_vector(g_size DOWNTO 0);
      p_result   : out std_logic_vector(g_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT four_quadrant_multiplier 
    GENERIC (
      g_size : integer := 31
    );
    PORT (
      p_sgnd      : in  std_logic;
      p_op_1      : in  std_logic_vector(g_size DOWNTO 0);
      p_op_2      : in  std_logic_vector(g_size DOWNTO 0);
      p_add       : in  std_logic_vector(g_size DOWNTO 0);
      p_result_lo : out std_logic_vector(g_size DOWNTO 0);
      p_result_hi : out std_logic_vector(g_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT barrel_shifter 
    GENERIC (
      g_size : integer := 31
    );
    PORT (
      p_arith  : in  std_logic;
      p_rotate : in  std_logic;
      p_cmd    : in  std_logic_vector(1 DOWNTO 0);
      p_op_1   : in  std_logic_vector(g_size DOWNTO 0);
      p_op_2   : in  std_logic_vector(g_size DOWNTO 0);
      p_result : out std_logic_vector(g_size DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL s_csel : std_logic_vector(4 DOWNTO 0);
  SIGNAL s_input_A : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_input_B : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_sgnd : std_logic;
  SIGNAL s_adder_sub : std_logic;
  SIGNAL s_adder_ovflw : std_logic;
  SIGNAL s_adder_result : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_logic_cmd : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_logic_result : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_div_remain : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_div_result : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_mul_result_hi : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_mul_result_lo : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_comp_cmd : std_logic_vector(2 DOWNTO 0);
  SIGNAL s_comp_result : std_logic;
  SIGNAL s_shft_ari : std_logic;
  SIGNAL s_shft_rot : std_logic;
  SIGNAL s_shft_cmd : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_shft_ctrl : std_logic_vector(3 DOWNTO 0);
  SIGNAL s_shft_result : std_logic_vector(g_word_size DOWNTO 0);
BEGIN
  -- Control Vector Binding
  s_csel <= p_ctrl(4 DOWNTO 0);
  -- Input A Multiplexing
  s_input_A <= p_input_A0;
  -- Input B Multiplexing
  s_input_B <= p_input_B0;
  -- Instances of Sub-Components
  adder : carry_select_adder GENERIC MAP (g_block_size => 7, g_blocks => 0) PORT MAP (s_sgnd, s_adder_sub, s_input_A, s_input_B, s_adder_result, s_adder_ovflw);
  logic : bit_manipulator GENERIC MAP (g_size => g_word_size) PORT MAP (s_input_A, s_input_B, s_logic_cmd, s_logic_result);
  div : divider GENERIC MAP (g_size => g_word_size) PORT MAP (s_sgnd, s_input_A, s_input_B, s_div_remain, s_div_result);
  mul : four_quadrant_multiplier GENERIC MAP (g_size => g_word_size) PORT MAP (s_sgnd, s_input_A, s_input_B, (OTHERS => '0'), s_mul_result_lo, s_mul_result_hi);
  comp : word_comparator GENERIC MAP (g_size => g_word_size) PORT MAP (s_input_A, s_input_B, s_comp_cmd, s_sgnd, s_comp_result);
  shft : barrel_shifter GENERIC MAP (g_size => g_word_size) PORT MAP (s_shft_ari, s_shft_rot, s_shft_cmd, s_input_A, s_input_B, s_shft_result);
  -- Output Multiplexers
  --
  -- Command	Index	Bitvector
  -- ADD_U 	0	00000
  -- SUB_U 	1	00001
  -- MUL_U 	2	00010
  -- DIV_U 	3	00011
  -- ADD 	4	00100
  -- SUB 	5	00101
  -- MUL 	6	00110
  -- DIV 	7	00111
  -- RR 	8	01000
  -- RL 	9	01001
  -- SRL 	10	01010
  -- SLL 	11	01011
  -- SRA 	12	01100
  -- AND 	13	01101
  -- OR 	14	01110
  -- XOR 	15	01111
  -- NOT 	16	10000
  -- GT_U 	17	10001
  -- LT_U 	18	10010
  -- GEQ_U 	19	10011
  -- LEQ_U 	20	10100
  -- GT 	21	10101
  -- LT 	22	10110
  -- GEQ 	23	10111
  -- LEQ 	24	11000
  -- EQ 	25	11001
  --
  -- Output 1 Multiplexing
  WITH s_csel SELECT p_output_1 <=
    s_adder_result WHEN "00000",
    s_adder_result WHEN "00001",
    s_mul_result_lo WHEN "00010",
    s_div_result WHEN "00011",
    s_adder_result WHEN "00100",
    s_adder_result WHEN "00101",
    s_mul_result_lo WHEN "00110",
    s_div_result WHEN "00111",
    s_shft_result WHEN "01000",
    s_shft_result WHEN "01001",
    s_shft_result WHEN "01010",
    s_shft_result WHEN "01011",
    s_shft_result WHEN "01100",
    s_logic_result WHEN "01101",
    s_logic_result WHEN "01110",
    s_logic_result WHEN "01111",
    s_logic_result WHEN "10000",
    "00000000" WHEN OTHERS;
  -- Output 2 Multiplexing
  WITH s_csel SELECT p_output_2 <=
    s_mul_result_hi WHEN "00010",
    s_div_remain WHEN "00011",
    s_mul_result_hi WHEN "00110",
    s_div_remain WHEN "00111",
    "00000000" WHEN OTHERS;
  -- Flag Multiplexing
  WITH s_csel SELECT p_flag <=
    s_adder_ovflw WHEN "00000",
    s_adder_ovflw WHEN "00001",
    s_adder_ovflw WHEN "00100",
    s_adder_ovflw WHEN "00101",
    s_comp_result WHEN "10001",
    s_comp_result WHEN "10010",
    s_comp_result WHEN "10011",
    s_comp_result WHEN "10100",
    s_comp_result WHEN "10101",
    s_comp_result WHEN "10110",
    s_comp_result WHEN "10111",
    s_comp_result WHEN "11000",
    s_comp_result WHEN "11001",
    '0' WHEN OTHERS;
  -- Command Tables
  WITH s_csel SELECT s_sgnd <=
    '1' WHEN "00100",
    '1' WHEN "00101",
    '0' WHEN "00010",
    '0' WHEN "00011",
    '1' WHEN "00110",
    '1' WHEN "00111",
    '1' WHEN "10101",
    '1' WHEN "10110",
    '1' WHEN "10111",
    '1' WHEN "11000",
    '0' WHEN OTHERS;
  -- Adder Control
  WITH s_csel SELECT s_adder_sub <=
    '0' WHEN "00000",
    '1' WHEN "00001",
    '0' WHEN "00100",
    '1' WHEN "00101",
    '0' WHEN OTHERS;
  -- Bitlogic Control
  WITH s_csel SELECT s_logic_cmd <=
    "00" WHEN "01101",
    "01" WHEN "01110",
    "10" WHEN "01111",
    "11" WHEN "10000",
    "00" WHEN OTHERS;
  -- Shifter/Rotater Control
  s_shft_cmd(0) <= s_shft_ctrl(0);
  s_shft_cmd(1) <= s_shft_ctrl(1);
  s_shft_ari <= s_shft_ctrl(2);
  s_shft_rot <= s_shft_ctrl(3);
  WITH s_csel SELECT s_shft_ctrl <=
    "1010" WHEN "01000",
    "1001" WHEN "01001",
    "0010" WHEN "01010",
    "0001" WHEN "01011",
    "0110" WHEN "01100",
    "0000" WHEN OTHERS;
  -- Comparator Control
  WITH s_csel SELECT s_comp_cmd <=
    "000" WHEN "10001",
    "001" WHEN "10010",
    "010" WHEN "10011",
    "011" WHEN "10100",
    "000" WHEN "10101",
    "001" WHEN "10110",
    "010" WHEN "10111",
    "011" WHEN "11000",
    "100" WHEN "11001",
    "000" WHEN OTHERS;

END behavior;