library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

Entity Mot_Pasos_PushButton is
	Port( clk: in std_logic;
			---Entradas--
			BA_BR: in  std_logic_vector(1 downto 0);
			---Salidas---
			Bobina: out std_logic_vector(3 downto 0)	
	);
END Mot_Pasos_PushButton;


Architecture Moore of Mot_Pasos_PushButton is
	Type Estados is (E0,E1,E2,E3,E4,E5,E6,E7);  
	signal EdoPres,EdoSig: estados;
	signal SigSalida: STD_LOGIC_VECTOR(3 downto 0);
	
	Signal div: std_logic_vector(15 downto 0);
	Signal clks: std_logic;
	---Divisor de frecuencia
	
	--Pruebas de negacion 
	signal NegBA_BR: std_logic_vector(1 downto 0);
	
	--Solo vibra el motor si se usan los botones de la tarjeta de10.
	---

	
	begin
	NegBA_BR <= not BA_BR;
	
		process(clk)
			begin
				if clk'event and clk='1' then 
					div <=div+1;
				end if;
			end process;
		clks <=div(15);
  ---Fin del divisor de frecuencia
  
  --Sincronizacion de los estados
		process(clks)
			begin	
				if rising_edge(clks) then
					EdoPres <= EdoSig;
					Bobina  <= SigSalida;
				end if;
			end process;
	---Fin de la sincronizacion de los estados
	
Process (EdoPres,BA_BR) begin
		case EdoPres is
			when E0 =>
				SigSalida <="1000";
				if BA_BR = "00" then  --Toma el valor de reposo  ---Usar comilla doble
					EdoSig <= E0;
				elsif BA_BR = "10" then
					EdoSig <= E1;
				elsif BA_BR = "01" then
				   EdoSig <= E7;
				else
					EdoSig <=E0;  ---En esta seccion si cumple si BA=1 y BR= 1
				end if; 
			when E1 =>
				SigSalida <= "1100"; --Las salidas del medio paso-- 
				if BA_BR ="00" then
					EdoSig <=E1;
				elsif BA_BR ="10" then
					EdoSig <=E2;
				elsif BA_BR ="01" then
					EdoSig <= E0; 
				else 
					EdoSig <=E1;
				end if;
				
			when E2 =>
				SigSalida<="0100";
				if	BA_BR ="00" then
					EdoSig<=E2;
				elsif BA_BR ="10" then
					EdoSig<=E3;
				elsif BA_BR ="01" then
					EdoSig<=E1;
				else
					EdoSig <=E2;
				end if;
		
			when E3 =>
				SigSalida <="0110";
				if BA_BR ="00" then
					EdoSig <=E3;
				elsif BA_BR="10" then
					EdoSig <=E4;
				elsif	BA_BR="01" then
					EdoSig <=E2;
				else
					EdoSig <=E3; 
				end if;
		
			when E4 =>
				  SigSalida <="0010";
			  if BA_BR = "00" then
					  EdoSig <=E4;
			  elsif BA_BR ="10" then
					  EdoSig <=E5;
			  elsif BA_BR = "01" then
					  EdoSig <=E3;
			  else 
					  EdoSig<=E4;
			  end if;
			  
			when E5 =>
				  SigSalida <="0011";
			  if BA_BR = "00" then
					  EdoSig <=E5;
			  elsif BA_BR ="10" then
					  EdoSig <=E6;
			  elsif BA_BR="01" then
					  EdoSig <= E4;
			  else
					  EdoSig <=E5;
			  end if;
			  
			when E6 =>
				  SigSalida <="0001";
			  if BA_BR = "00" then
					  EdoSig <=E6;
			  elsif BA_BR ="10" then
					  EdoSig <= E7;
			  elsif BA_BR ="01" then
					  EdoSig <=E5;
			  else
					  EdoSig <=E6;
			  end if;
			  
		    when E7 =>
				  SigSalida <="1001";
			  if BA_BR = "00" then
					  EdoSig <=E7;
			  elsif BA_BR ="10" then
					  EdoSig <=E0;
			  elsif BA_BR ="01" then
					  EdoSig <=E6;
			  else
					  EdoSig <=E7;
			end if;
		end case;
	 end process;
end Moore;	 
		