library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Servomotor is
	Port( clk : in std_logic;
			Inc:  in std_logic;
			Dec:  in std_logic;
			Control : out std_logic);
end Servomotor;

architecture Behavorial of Servomotor is
	component divisor is
		Port( clk : in std_logic;
				div_clk: out std_logic);
	end component;
	component PWM is
		Port ( Reloj : in STD_LOGIC;
				 D     : in STD_LOGIC_VECTOR (7 downto 0);
				 S     : out STD_LOGIC);
	end component;
	
	signal reloj :STD_LOGIC;
	signal ancho :STD_LOGIC_VECTOR (7 downto 0) :=X"0F";
	--signal negInc, negDec : STD_LOGIC;
begin

	U1: divisor port map (clk,reloj);
	U2: PWM port map (reloj,ancho,control);
	--negInc <= not Inc;
	--negDec <= not Dec;
	
	process (reloj,Inc, Dec)
		variable valor: STD_LOGIC_VECTOR (7 downto 0) := X"22";
		variable cuenta : integer range 0 to 1023 := 0;
	begin
		if reloj = '1' and reloj'event then 
			if cuenta >0 then
				cuenta:= cuenta-1;
			else 
				if Inc='1' and valor<X"3C" then  ---Incremento
					valor:= valor+1;
				elsif Dec='1' and valor>X"0D" then  ---Decremento
					valor:= valor-1;
				end if;
				cuenta :=1023;
				ancho <= valor;
			end if;
		end if;
	end process;
end Behavorial;