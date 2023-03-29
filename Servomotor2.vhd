library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Servomotor2 is
	Port( clk : in std_logic;
			Inc2:  in std_logic;
			Dec2:  in std_logic;
			Control2: out std_logic);
end Servomotor2;

architecture Behavorial of Servomotor2 is
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
	U2: PWM port map (reloj,ancho,control2);
	--negInc <= not Inc;
	--negDec <= not Dec;
	
	process (reloj,Inc2, Dec2)
		variable valor: STD_LOGIC_VECTOR (7 downto 0) := X"22";
		variable cuenta : integer range 0 to 1023 := 0;
	begin
		if reloj = '1' and reloj'event then 
			if cuenta >0 then
				cuenta:= cuenta-1;
			else 
				if Inc2='1' and valor<X"3C" then  ---Incremento
					valor:= valor+1;
				elsif Dec2='1' and valor>X"0D" then  ---Decremento
					valor:= valor-1;
				end if;
				cuenta :=1023;
				ancho <= valor;
			end if;
		end if;
	end process;
end Behavorial;