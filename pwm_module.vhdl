-- Auto generated

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pwm_module IS
  PORT (
    clock :	in		std_logic;
	 pwm_dc	:	in		std_logic_vector(7 DOWNTO 0);
	 pwm_out :	out	std_logic
  );
END pwm_module;

ARCHITECTURE behavior OF pwm_module IS
SIGNAL counter : std_logic_vector(7 DOWNTO 0);
BEGIN
	PROCESS(clock)
	BEGIN
		IF clock'event and clock = '1' THEN
			counter <= std_logic_vector(unsigned(counter) + 1);
		ELSE
			counter <= counter;
		END IF;
	END PROCESS;
	PROCESS(counter)
	BEGIN
		IF unsigned(counter) < unsigned(pwm_dc) THEN
			pwm_out <= '1';
		ELSE 
			pwm_out <= '0';
		END IF;
	END PROCESS;
END behavior;