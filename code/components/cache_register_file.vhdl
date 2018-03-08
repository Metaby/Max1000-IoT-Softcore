-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY cache_register_file IS
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
END cache_register_file;

ARCHITECTURE behavior OF cache_register_file IS
  TYPE registerArray IS ARRAY(31 DOWNTO 0) OF std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_port0_isel : std_logic_vector(1 DOWNTO 0);
  SIGNAL s_port0_inputSelect : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_port0_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port0_write : std_logic;
  SIGNAL s_port1_inputSelect : std_logic_vector(g_word_size DOWNTO 0);
  SIGNAL s_port1_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port1_write : std_logic;
  SIGNAL s_port2_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port3_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port4_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port5_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port6_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_port7_addressSelect : std_logic_vector(g_address_size DOWNTO 0);
  SIGNAL s_registers : registerArray;
BEGIN
  WITH s_port0_isel SELECT s_port0_inputSelect <=
    p_port0_input0 WHEN "00",
    p_port0_input1 WHEN "01",
    p_port0_input2 WHEN "10",
    p_port0_input3 WHEN "11",
    (OTHERS => '0') WHEN OTHERS;
  s_port0_addressSelect <= p_port0_address0;
  s_port1_inputSelect <= p_port1_input0;
  s_port1_addressSelect <= p_port1_address0;
  s_port2_addressSelect <= p_port2_address0;
  s_port3_addressSelect <= p_port3_address0;
  s_port4_addressSelect <= p_port4_address0;
  s_port5_addressSelect <= p_port5_address0;
  s_port6_addressSelect <= p_port6_address0;
  s_port7_addressSelect <= p_port7_address0;
  s_port0_isel <= p_ctrl(1 DOWNTO 0);
  s_port0_write <= p_ctrl(2);
  s_port1_write <= p_ctrl(3);
  PROCESS (p_clk) BEGIN
    IF rising_edge(p_clk) THEN
      IF s_port0_write = '1' THEN
        s_registers(to_integer(unsigned(s_port0_addressSelect))) <= s_port0_inputSelect;
      END IF;
      IF s_port1_write = '1' THEN
        s_registers(to_integer(unsigned(s_port1_addressSelect))) <= s_port1_inputSelect;
      END IF;
      p_port2_output <= s_registers(to_integer(unsigned(s_port2_addressSelect)));
      p_port3_output <= s_registers(to_integer(unsigned(s_port3_addressSelect)));
      p_port4_output <= s_registers(to_integer(unsigned(s_port4_addressSelect)));
      p_port5_output <= s_registers(to_integer(unsigned(s_port5_addressSelect)));
      p_port6_output <= s_registers(to_integer(unsigned(s_port6_addressSelect)));
      p_port7_output <= s_registers(to_integer(unsigned(s_port7_addressSelect)));
    END IF;
  END PROCESS;

END behavior;