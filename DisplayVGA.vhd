library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DisplayVGA is
	generic( --Constantes para monitor VGA en 640x480
			constant h_pulse : integer := 96;
			constant h_bp : integer := 48;
			constant h_pixels : integer := 640;
			constant h_fp : integer := 16;
			constant v_pulse : integer := 2;
			constant v_bp : integer := 33;
			constant v_pixels : integer := 480;
			constant v_fp : integer := 10
	);
	port( clk50MHz : in std_logic;
			red : out std_logic_vector(3 downto 0);
			green : out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync : out std_logic;
			v_sync : out std_logic;
			sensor : in std_logic);
end entity DisplayVGA;

architecture behavioral of DisplayVGA is
	component SincroniaVGA is
		port( reloj_pixel : in std_logic;
				h_pulse : in integer;
				h_fp : in integer;
				h_pixels : in integer;
				h_count : in integer;
				v_pulse : in integer;
				v_fp : in integer;
				v_pixels : in integer;
				v_count : in integer;

				row : out integer;
				column : out integer;
				h_sync : out std_logic;
				v_sync : out std_logic);

	end component;
	
	constant h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
	constant v_period : integer := v_pulse + v_bp + v_pixels + v_fp;
	signal h_count : integer range 0 to h_period - 1 :=0;
	signal v_count : integer range 0 to v_period - 1 :=0;
	signal column : integer range 0 to h_period - 1 :=0;
	signal row : integer range 0 to v_period - 1 :=0;
	signal reloj_pixel : std_logic := '0';
	signal display_ena : std_logic := '0';
	--gfedcba
	constant cero : std_logic_vector(6 downto 0) := "0111111";
	constant uno : std_logic_vector(6 downto 0) := "0000110";
	constant dos : std_logic_vector(6 downto 0) := "1011011";
	constant tres : std_logic_vector(6 downto 0) := "1001111";
	constant cuatro : std_logic_vector(6 downto 0) := "1100110";
	constant cinco : std_logic_vector(6 downto 0) := "1101101";
	constant seis : std_logic_vector(6 downto 0) := "1111101";
	constant siete : std_logic_vector(6 downto 0) := "0000111";
	constant ocho : std_logic_vector(6 downto 0) := "1111111";
	constant nueve : std_logic_vector(6 downto 0) := "1110011";
	signal conectornum : std_logic_vector(6 downto 0);
	signal cont2Hz : integer range 0 to 25000001 := 0;
	signal relojMedioSeg : std_logic := '0';
	signal unid : integer range 0 to 10 := 0;
	signal dece : integer range 0 to 2 := 0;
	signal digito : integer range 0 to 10 := 0;
	signal disp : std_logic := '0';
	signal rap : std_logic := '0';
	signal segundo : std_logic;
	
	begin
	S : SincroniaVGA port map
		(reloj_pixel,h_pulse,h_fp,h_pixels,h_count,v_pulse,
			v_fp,v_pixels,v_count,row,column,h_sync,v_sync);

	relojPixel: process(clk50MHz,unid,dece)
		variable cuenta: std_logic_vector(27 downto 0):=x"0000000";
		begin
		if rising_edge(clk50MHz) then
			reloj_pixel <= not reloj_pixel; --25MHz
			if(cuenta = x"48009E0") then
				cuenta:=x"0000000";
			else
				cuenta:=cuenta+1;
			end if;
		end if;
		rap<=cuenta(6);
		segundo<= cuenta(23);
	end process relojPixel;

	contador20: process(segundo,unid,dece)
		begin
		if rising_edge(segundo) then
			if dece=2 and unid=0 then
				dece<=0;
			else
				if sensor='0' then
					if unid<9 then
						unid<=unid+1;
					else
						unid<=0;
						dece<=dece+1;
					end if;
				end if;
			end if;
		end if;
	end process contador20;
	
	
	multiplex: process(rap)
			begin
			if rap='0' then
					digito<=unid;
					disp<='0';
			else
					digito<=dece;
					disp<='1';
			end if;
		end process multiplex;

	contadores : process(reloj_pixel) -- H_periodo=800, V_periodo=525
		begin
		if rising_edge(reloj_pixel) then
			if h_count<(h_period-1) then
				h_count<=h_count+1;
			else
				h_count<=0;
				if v_count<(v_period-1) then
					v_count<=v_count+1;
				else
					v_count<=0;
				end if;
			end if;
		end if;
	end process contadores;

	display_enable: process(reloj_pixel) -- h_pixels=640; y_pixels=480
		begin
		if rising_edge(reloj_pixel) then
			if (h_count < h_pixels and v_count < v_pixels) then
				display_ena <= '1';
			else
				display_ena <= '0';
			end if;
		end if;
	end process display_enable;

	generador_imagen1 : process(conectornum,row,column,display_ena,disp)
	begin
	if(display_ena='1') then
		case(conectornum) is
			when cero =>
				if disp='0' then
					if((row>200 and row<210) and (column>370 and column<400)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>400 and column<410)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>400 and	column<410)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>280 and row<290) and (column>370 and column<400)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>360 and column<370)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>360 and column<370)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				else
					if((row>200 and row<210) and (column>270 and column<300)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>300 and column<310)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>300 and column<310)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>280 and row<290) and (column>270 and column<300)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>260 and column<270)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>260 and column<270)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				end if;

			when uno =>
				if disp='0' then
					if((row>210 and row<240) and (column>400 and column<410)) then
						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>400 and column<410)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				else
					if((row>210 and row<240) and (column>300 and column<310)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>300 and column<310)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				end if;
				
			when dos =>
				if disp='0' then
					if((row>200 and row<210) and (column>370 and column<400)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>400 and column<410)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>280 and row<290) and (column>370 and column<400)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>360 and column<370)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>240 and row<250) and (column>370 and column<400)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				else
					if((row>200 and row<210) and (column>270 and column<300)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>210 and row<240) and (column>300 and column<310)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>280 and row<290) and (column>270 and column<300)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>250 and row<280) and (column>260 and column<270)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					elsif((row>240 and row<250) and (column>270 and 	column<300)) then

						red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
					else
						red <= (others => '0');
						green <= (others => '0'); -- fondo negro
						blue <= (others => '0');
					end if;
				end if;
				
			when tres =>
				if((row>200 and row<210) and (column>370 and column<400)) then

					red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
				elsif((row>210 and row<240) and (column>400 and column<410)) then

					red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');

				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');

				elsif((row>280 and row<290) and (column>370 and column<400)) then

					red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');

				elsif((row>240 and row<250) and (column>370 and column<400)) then

					red <= (others => '0');
						green <= (others => '1'); -- b verde
						blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when cuatro =>
				if((row>210 and row<240) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');

				elsif((row>240 and row<250) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when cinco =>
				if((row>200 and row<210) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>280 and row<290) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>240 and row<250) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when seis =>
				if((row>200 and row<210) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>280 and row<290) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>240 and row<250) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when siete =>
				if((row>200 and row<210) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when ocho =>
				if((row>200 and row<210) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>400 and column<410)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');

				elsif((row>280 and row<290) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>250 and row<280) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>210 and row<240) and (column>360 and column<370)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				elsif((row>240 and row<250) and (column>370 and column<400)) then

					red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
				else
					red <= (others => '0');
					green <= (others => '0'); -- fondo negro
					blue <= (others => '0');
				end if;
				
			when nueve =>
			if((row>200 and row<210) and (column>370 and column<400)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
			elsif((row>210 and row<240) and (column>400 and	column<410)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
			elsif((row>250 and row<280) and (column>400 and column<410)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
			elsif((row>280 and row<290) and (column>370 and column<400)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
			elsif((row>210 and row<240) and (column>360 and column<370)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');

			elsif((row>240 and row<250) and (column>370 and column<400)) then

				red <= (others => '0');
					green <= (others => '1'); -- b verde
					blue <= (others => '0');
			else
				red <= (others => '0');
				green <= (others => '0'); -- fondo negro
				blue <= (others => '0');
			end if;
			
			when others =>
				red <= (others => '0');
				green <= (others => '0'); -- fondo negro
				blue <= (others => '0');

			end case;
			else
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '0');
			end if;
	end process generador_imagen1;
	with digito select conectornum <= --decodificador para los numeros
		"0111111" when 0,
		"0000110" when 1,
		"1011011" when 2,
		"1001111" when 3,
		"1100110" when 4,
		"1101101" when 5,
		"1111101" when 6,
		"0000111" when 7,
		"1111111" when 8,
		"1110011" when 9,
		"0000000" when others;
end architecture behavioral;