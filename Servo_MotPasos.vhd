library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

Entity Servo_MotPasos is
	Port(
			clk: in std_logic;
			BA_BR: in std_logic_vector(1 downto 0);
			Inc:  in std_logic;
			Dec:  in std_logic;
			Control: out std_logic;
			Inc2:  in std_logic;
			Dec2:  in std_logic;
			Control2: out std_logic;
		   Inc3:  in std_logic;
			Dec3:  in std_logic;
			Control3: out std_logic;
			clk50MHz : in std_logic;
			red : out std_logic_vector(3 downto 0);
			green : out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync : out std_logic;
			v_sync : out std_logic;
			sensor : in std_logic;
			Bobina: out std_logic_vector(3 downto 0)
	);
end Servo_MotPasos;


Architecture Behavioral of Servo_MotPasos is
Begin
	u1: entity work.Mot_Pasos_PushButton(Moore) port map(clk,BA_BR,Bobina);
	u2: entity work.Servomotor(Behavorial) port map(clk,Inc,Dec,Control);
	u3: entity work.Servomotor2(Behavorial) port map(clk,Inc2,Dec2,Control2);
	u4: entity work.Servomotor3(Behavorial) port map(clk,Inc3,Dec3,Control3);
	u5: entity work.DisplayVGA(behavioral)  port map(clk50MHz,red,green,blue,h_sync,v_sync,sensor);
end Behavioral;