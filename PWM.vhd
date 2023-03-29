library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PWM is
	Port( Reloj : in STD_LOGIC;
			D     : in STD_LOGIC_VECTOR( 7 downto 0);
			S:      out STD_LOGIC);
end PWM;

architecture Behavorial of PWM is
begin
		process(Reloj)
			variable Cuenta : integer range 0 to 255 := 0;
		begin
			if Reloj='1' and Reloj'event then
				Cuenta :=(Cuenta +1) mod 256;
				if Cuenta <D then
					S <= '1';
				else
					S <='0';
				end if;
			end if;
		end process;
	end Behavorial;