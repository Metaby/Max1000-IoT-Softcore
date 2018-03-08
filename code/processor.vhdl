-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY processor IS
  GENERIC (
    g_word_size : integer := 7
  );
  PORT (
    p_clk : in std_logic;
    p_reset : in std_logic;
    p_pmem_dat : in std_logic_vector(7 DOWNTO 0);
    p_mmi : in std_logic_vector(7 DOWNTO 0);
    p_mpmem_dat : in std_logic_vector(23 DOWNTO 0);
    p_pmem_adr : out std_logic_vector(7 DOWNTO 0);
    p_mpmem_adr : out std_logic_vector(15 DOWNTO 0);
    p_leds : out std_logic_vector(7 DOWNTO 0);
    p_uart_out : out std_logic_vector(7 DOWNTO 0);
    p_per_ctrl : out std_logic_vector(7 DOWNTO 0);
    p_pwm0_dc : out std_logic_vector(7 DOWNTO 0);
    p_pwm1_dc : out std_logic_vector(7 DOWNTO 0)
  );
END processor;

ARCHITECTURE behavior OF processor IS
  COMPONENT pc_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in std_logic;
      p_input0 : in std_logic_vector(7 DOWNTO 0);
      p_word : out std_logic_vector(7 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT mpc_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in std_logic;
      p_input0 : in std_logic_vector(15 DOWNTO 0);
      p_word : out std_logic_vector(15 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT operand1_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in std_logic;
      p_input0 : in std_logic_vector(7 DOWNTO 0);
      p_word : out std_logic_vector(7 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT operand2_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in  std_logic_vector(3 DOWNTO 0);
      p_input0 : in std_logic_vector(7 DOWNTO 0);
      p_input1 : in std_logic_vector(7 DOWNTO 0);
      p_input2 : in std_logic_vector(7 DOWNTO 0);
      p_input3 : in std_logic_vector(7 DOWNTO 0);
      p_input4 : in std_logic_vector(7 DOWNTO 0);
      p_word : out std_logic_vector(7 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT address_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in std_logic;
      p_input0 : in std_logic_vector(7 DOWNTO 0);
      p_word : out std_logic_vector(7 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT alu_status_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in  std_logic_vector(2 DOWNTO 0);
      p_input0 : in std_logic;
      p_input1 : in std_logic;
      p_input2 : in std_logic;
      p_word : out std_logic
    );
  END COMPONENT;
  COMPONENT alu_carry_register
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_ctrl : in  std_logic_vector(2 DOWNTO 0);
      p_input0 : in std_logic;
      p_input1 : in std_logic;
      p_input2 : in std_logic;
      p_word : out std_logic
    );
  END COMPONENT;
  COMPONENT cmd_trans_rom
    GENERIC (
      g_address_size : integer := 7;
      g_word_size : integer := 15
    );
    PORT (
      p_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_word : out std_logic_vector(g_word_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT cache_register_file
    GENERIC (
      g_address_size : integer := 4;
      g_word_size : integer := 7
    );
    PORT (
      p_clk : in std_logic;
      p_rst : in std_logic;
      p_port0_input0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_port0_input1 : in std_logic_vector(g_word_size DOWNTO 0);
      p_port0_input2 : in std_logic_vector(g_word_size DOWNTO 0);
      p_port0_input3 : in std_logic_vector(g_word_size DOWNTO 0);
      p_port0_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port1_input0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_port1_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port2_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port2_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_port3_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port3_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_port4_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port4_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_port5_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port5_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_port6_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port6_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_port7_address0 : in std_logic_vector(g_address_size DOWNTO 0);
      p_port7_output : out std_logic_vector(g_word_size DOWNTO 0);
      p_ctrl : in std_logic_vector(3 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT pc_inc_alu
    GENERIC (
      g_word_size : integer := 7
    );
    PORT (
      p_input_A0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_input_B0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_flag : out std_logic;
      p_output_1 : out std_logic_vector(g_word_size DOWNTO 0);
      p_output_2 : out std_logic_vector(g_word_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT mpc_inc_alu
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
  END COMPONENT;
  COMPONENT math_alu
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
  END COMPONENT;
  COMPONENT m1_multiplexer
    GENERIC (
      g_word_size : integer := 7
    );
    PORT (
      p_input0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_input1 : in std_logic_vector(g_word_size DOWNTO 0);
      p_isel : in std_logic;
      p_word : out std_logic_vector(g_word_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT m2_multiplexer
    GENERIC (
      g_word_size : integer := 15
    );
    PORT (
      p_input0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_input1 : in std_logic_vector(g_word_size DOWNTO 0);
      p_isel : in std_logic;
      p_word : out std_logic_vector(g_word_size DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT mc_in_multiplexer
    GENERIC (
      g_word_size : integer := 23
    );
    PORT (
      p_input0 : in std_logic_vector(g_word_size DOWNTO 0);
      p_word : out std_logic_vector(g_word_size DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL ps_pmem_adr : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_mpmem_adr : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_operand1_register_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_operand2_register_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_address_register_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_alu_status_register_out : std_logic;
  SIGNAL s_alu_carry_register_out : std_logic;
  SIGNAL s_cmd_trans_rom_out : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_cache_register_file_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_leds : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_uart_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_per_ctrl : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_pwm0_dc : std_logic_vector(7 DOWNTO 0);
  SIGNAL ps_pwm1_dc : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_pc_inc_alu_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_mpc_inc_alu_out : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_math_alu_low : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_math_alu_high : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_math_alu_status : std_logic;
  SIGNAL s_m1_multiplexer_out : std_logic_vector(7 DOWNTO 0);
  SIGNAL s_m2_multiplexer_out : std_logic_vector(15 DOWNTO 0);
  SIGNAL s_ctrl_vector : std_logic_vector(23 DOWNTO 0);
BEGIN
  pc_register_instance : pc_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(0),
      s_m1_multiplexer_out,
      ps_pmem_adr
    );
  mpc_register_instance : mpc_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(1),
      s_m2_multiplexer_out,
      ps_mpmem_adr
    );
  operand1_register_instance : operand1_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(2),
      s_cache_register_file_out,
      s_operand1_register_out
    );
  operand2_register_instance : operand2_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(6 DOWNTO 3),
      s_cache_register_file_out,
      "00000000",
      "00000001",
      s_math_alu_low,
      s_math_alu_high,
      s_operand2_register_out
    );
  address_register_instance : address_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(7),
      p_pmem_dat,
      s_address_register_out
    );
  alu_status_register_instance : alu_status_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(10 DOWNTO 8),
      s_math_alu_status,
      '0',
      '1',
      s_alu_status_register_out
    );
  alu_carry_register_instance : alu_carry_register
    PORT MAP (
      p_clk,
      p_reset,
      s_ctrl_vector(13 DOWNTO 11),
      s_math_alu_status,
      '0',
      '1',
      s_alu_carry_register_out
    );
  cmd_trans_rom_instance : cmd_trans_rom
    GENERIC MAP (g_address_size => 7, g_word_size => 15)
    PORT MAP (
      p_pmem_dat,
      s_cmd_trans_rom_out
    );
  cache_register_file_instance : cache_register_file
    GENERIC MAP (g_address_size => 4, g_word_size => 7)
    PORT MAP (
      p_clk,
      p_reset,
      "00000000",
      p_pmem_dat,
      s_math_alu_low,
      s_math_alu_high,
      s_address_register_out(4 DOWNTO 0),
      p_mmi,
      "10100",
      s_address_register_out(4 DOWNTO 0),
      s_cache_register_file_out,
      "11111",
      ps_leds,
      "11110",
      ps_uart_out,
      "11101",
      ps_per_ctrl,
      "11100",
      ps_pwm0_dc,
      "11011",
      ps_pwm1_dc,
      s_ctrl_vector(17 DOWNTO 14)
    );  pc_inc_alu_instance : pc_inc_alu
    GENERIC MAP (g_word_size => 7)
    PORT MAP (
      ps_pmem_adr,
      "00000001",
      OPEN,
      s_pc_inc_alu_out,
      OPEN
    );
  mpc_inc_alu_instance : mpc_inc_alu
    GENERIC MAP (g_word_size => 15)
    PORT MAP (
      ps_mpmem_adr,
      "0000000000000001",
      OPEN,
      s_mpc_inc_alu_out,
      OPEN
    );
  math_alu_instance : math_alu
    GENERIC MAP (g_word_size => 7)
    PORT MAP (
      s_operand1_register_out,
      s_operand2_register_out,
      s_ctrl_vector(22 DOWNTO 18),
      s_math_alu_status,
      s_math_alu_low,
      s_math_alu_high
    );
  m1_multiplexer_instance : m1_multiplexer
    GENERIC MAP (g_word_size => 7)
    PORT MAP (
      s_pc_inc_alu_out,
      p_pmem_dat,
      s_alu_status_register_out,
      s_m1_multiplexer_out
    );
  m2_multiplexer_instance : m2_multiplexer
    GENERIC MAP (g_word_size => 15)
    PORT MAP (
      s_mpc_inc_alu_out,
      s_cmd_trans_rom_out,
      s_ctrl_vector(23),
      s_m2_multiplexer_out
    );
  mc_in_multiplexer_instance : mc_in_multiplexer
    GENERIC MAP (g_word_size => 23)
    PORT MAP (
      p_mpmem_dat,
      s_ctrl_vector
    );
  p_pmem_adr <= ps_pmem_adr;
  p_mpmem_adr <= ps_mpmem_adr;
  p_leds <= ps_leds;
  p_uart_out <= ps_uart_out;
  p_per_ctrl <= ps_per_ctrl;
  p_pwm0_dc <= ps_pwm0_dc;
  p_pwm1_dc <= ps_pwm1_dc;

END behavior;