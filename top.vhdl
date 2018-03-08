-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_misc.all;

ENTITY top IS
  PORT (
    CLOCK12 : in  std_logic;
	 BTN : in std_logic;
    LED0 : out std_logic;
    LED1 : out std_logic;
    LED2 : out std_logic;
    LED3 : out std_logic;
    LED4 : out std_logic;
    LED5 : out std_logic;
    LED6 : out std_logic;
    LED7 : out std_logic;
	 RX : out std_logic;
	 D3 : out std_logic;
	 D4 : out std_logic;
	 D5 : out std_logic;
	 D6 : out std_logic
  );
END top;

ARCHITECTURE behavior OF top IS
	COMPONENT processor IS
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
	END COMPONENT;
	COMPONENT UART_TX IS
		GENERIC (
			g_CLKS_PER_BIT : integer := 115     -- Needs to be set correctly
		);
		PORT (
			i_Clk       : in  std_logic;
			i_TX_DV     : in  std_logic;
			i_TX_Byte   : in  std_logic_vector(7 downto 0);
			o_TX_Active : out std_logic;
			o_TX_Serial : out std_logic;
			o_TX_Done   : out std_logic
		);
	END COMPONENT;
	COMPONENT pwm_module IS
		PORT (
			clock		:	in		std_logic;
			pwm_dc	:	in		std_logic_vector(7 DOWNTO 0);
			pwm_out	:	out	std_logic
		);
	END COMPONENT;
	COMPONENT servo_module IS
		PORT (
			clock		:	in		std_logic;
			pwm_dc	:	in		std_logic_vector(7 DOWNTO 0);
			pwm_out	:	out	std_logic
		);
	END COMPONENT;
	COMPONENT progmem IS
		PORT (
		address	: IN std_logic_vector (7 DOWNTO 0);
		clock		: IN std_logic  := '1';
		q			: OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mpmem IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT shifted_clock IS
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			c1		: OUT STD_LOGIC 
		);
	END COMPONENT;
	-- SIGNALS
	SIGNAL leds : std_logic_vector(7 DOWNTO 0);
	SIGNAL uart_out : std_logic_vector(7 DOWNTO 0);
	SIGNAL per_ctrl : std_logic_vector(7 DOWNTO 0);
	SIGNAL pwm0_dc : std_logic_vector(7 DOWNTO 0);
	SIGNAL pwm1_dc : std_logic_vector(7 DOWNTO 0);
	SIGNAL pmem_adr : std_logic_vector(7 DOWNTO 0);
	SIGNAL pmem_dat : std_logic_vector(7 DOWNTO 0);
	SIGNAL mpmem_adr : std_logic_vector(15 DOWNTO 0);
	SIGNAL mpmem_dat : std_logic_vector(23 DOWNTO 0);
	SIGNAL last_pmem_dat : std_logic_vector(7 DOWNTO 0);
	SIGNAL uart_send : std_logic;
	SIGNAL uart_send_lock : std_logic;
	SIGNAL cpu_clk : std_logic;
	SIGNAL pwm_clk : std_logic;
	BEGIN
	-- lock uart sending
	PROCESS(BTN)
	BEGIN
		IF CLOCK12'event and CLOCK12 = '1' THEN
			IF per_ctrl(0) = '1' and uart_send_lock = '0' THEN
				uart_send <= '1';
				uart_send_lock <= '1';
			ELSIF per_ctrl(0) = '0' THEN
				uart_send_lock <= '0';
			ELSE
				uart_send <= '0';
			END IF;
		END IF;
	END PROCESS;
	-- DEBUGGER
	PROCESS(CLOCK12)
	BEGIN
		IF CLOCK12'event and CLOCK12 = '1' THEN
			IF or_reduce(pmem_dat xor last_pmem_dat) = '1' THEN
				per_ctrl(0) <= '1';
			ELSE
				per_ctrl(0) <= '0';
			END IF;
			last_pmem_dat <= pmem_dat;
		END IF;
	END PROCESS;
	-- MAPPING
	uart_out <= pmem_dat;
	LED0 <= leds(0);
	LED1 <= leds(1);
	LED2 <= leds(2);
	LED3 <= leds(3);
	LED4 <= leds(4);
	LED5 <= leds(5);
	LED6 <= leds(6);
	LED7 <= leds(7);
	D3 <= pwm_clk;
	-- INSTANCES
	cpu0_instance : processor
		GENERIC MAP (
			g_word_size => 7
		)
		PORT MAP (
			cpu_clk,
			not BTN,
			pmem_dat,
			"00000000",
			mpmem_dat,
			pmem_adr,
			mpmem_adr,
			leds,
			open,--uart_out,
			open,--per_ctrl,
			pwm0_dc,
			pwm1_dc
		);
	uart_tx_instance : UART_TX
		GENERIC MAP (
			g_CLKS_PER_BIT => 104
		)
		PORT MAP (
			CLOCK12,
			uart_send,
			uart_out,
			open,
			RX,
			open
		);
	pwm0_instance : servo_module
		PORT MAP (
			pwm_clk,
			pwm0_dc,
			D4
		);
	pwm1_instance : servo_module
		PORT MAP (
			pwm_clk,
			pwm1_dc,
			D5
		);
	progmem_instance : progmem
		PORT MAP (
			pmem_adr,
			CLOCK12,
			pmem_dat
		);
	mpmem_instance : mpmem
		PORT MAP (
			mpmem_adr(10 DOWNTO 0),
			CLOCK12,
			mpmem_dat
		);
	shifted_clock_instance : shifted_clock
		PORT MAP (
			CLOCK12,
			cpu_clk,
			pwm_clk
		);
END behavior;