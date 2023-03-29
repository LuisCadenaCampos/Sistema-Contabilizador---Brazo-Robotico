library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SincroniaVGA is
	port( reloj_pixel : in std_logic;
			h_pulse  : in integer;-- := 96;
			h_fp 		: in integer;-- := 48;
			h_pixels : in integer;-- := 640;
			h_count	: in integer;-- := 16;
			v_pulse 	: in integer;-- := 2;
			v_fp 		: in integer;-- := 33;
			v_pixels : in integer;-- := 480;
			v_count 		: in integer;-- := 10
			row		: out integer;
			column	: out integer;
			h_sync : out std_logic;
			v_sync : out std_logic);
end entity SincroniaVGA;

architecture behavioral of SincroniaVGA is

begin
senial_hsync : process(reloj_pixel) --h_pixel + h_fp + h_pulse = 784
	begin
		if rising_edge(reloj_pixel) then
			if h_count>(h_pixels + h_fp) or h_count>(h_pixels + h_fp + h_pulse) then
				h_sync<='0';
			else
				h_sync<='1';
			end if;
		end if;
	end process senial_hsync;
		
		
	senial_vsync : process(reloj_pixel) --v_pixel + v_fp + v_pulse = 525
	begin --checar si se en parte visible es 1 o 0
		if rising_edge(reloj_pixel) then
			if v_count>(v_pixels + v_fp) or v_count>(v_pixels + v_fp + v_pulse) then
				v_sync<='0';
			else
				v_sync<='1';
			end if;
		end if;
	end process senial_vsync;
	
	
	coords_pixel: process(reloj_pixel)
	begin    -- asignar una coordenada en parte visible
		if rising_edge(reloj_pixel) then
			if (h_count < h_pixels) then
				column <= h_count;
			end if;
			if (v_count < v_pixels) then
				row <= v_count;
			end if;
		end if;
	end process coords_pixel;
	
end architecture behavioral;