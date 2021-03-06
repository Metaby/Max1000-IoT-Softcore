LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY servo_module IS
  PORT (
    clock :	in		std_logic;
	 pwm_dc	:	in		std_logic_vector(7 DOWNTO 0);
	 pwm_out :	out	std_logic
  );
END servo_module;

ARCHITECTURE behavior OF servo_module IS
SIGNAL counter : std_logic_vector(12 DOWNTO 0);
BEGIN
	PROCESS(clock)
	BEGIN
		IF clock'event and clock = '1' THEN
			IF counter = std_logic_vector(to_unsigned(5120, counter'length)) THEN
				counter <= (OTHERS => '0');
			ELSE
				counter <= std_logic_vector(unsigned(counter) + 1);
			END IF;
		ELSE
			counter <= counter;
		END IF;
	END PROCESS;
	PROCESS(counter)
	BEGIN
		IF unsigned(counter) < unsigned('1' & pwm_dc) THEN
			pwm_out <= '1';
		ELSE 
			pwm_out <= '0';
		END IF;
	END PROCESS;
END behavior;