library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Divisor is
	Port(clk : in std_logic;
			div_clk : out std_logic);
end Divisor;

architecture Behavorial of Divisor is
	begin
		process (clk)
			constant N: integer := 10;
			variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
		begin
			if rising_edge (clk) then
				cuenta := cuenta+1;
			end if;
			div_clk <= cuenta (N);
			end process;
End Behavorial;