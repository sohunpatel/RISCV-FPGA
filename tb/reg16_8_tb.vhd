----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2021 12:57:41 AM
-- Design Name: 
-- Module Name: reg16_8_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg16_8_tb is

end reg16_8_tb;

architecture Behavioral of reg16_8_tb is

    component reg16_8
    port(
        I_clk : in std_logic;
        I_en : in std_logic;
        I_dataD : in std_logic_vector(15 downto 0);
        O_dataA : out std_logic_vector(15 downto 0);
        O_dataB : out std_logic_vector(15 downto 0);
        I_selA : in std_logic_vector(2 downto 0);
        I_selB : in std_logic_vector(2 downto 0);
        I_selD : in std_logic_vector(2 downto 0);
        I_we : in std_logic
    );
    end component;
    
    -- Inputs
    signal I_clk : std_logic := '0';
   signal I_en : std_logic := '0';
   signal I_dataD : std_logic_vector(15 downto 0) := (others => '0');
   signal I_selA : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selB : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selD : std_logic_vector(2 downto 0) := (others => '0');
   signal I_we : std_logic := '0';
   
   --Outputs
   signal O_dataA : std_logic_vector(15 downto 0);
   signal O_dataB : std_logic_vector(15 downto 0);
   
   -- Clock period definitions
   constant I_clk_period : time := 10 ns;
begin

    -- Instantiate the Unit Under Test
    uut: reg16_8 port map (
            I_clk => I_clk,
            I_en => I_en,
            I_dataD => I_dataD,
            O_dataA => O_dataA,
            O_dataB => O_dataB,
            I_selA => I_selA,
            I_selB => I_selB,
            I_selD => I_selD,
            I_we => I_we
        );
        
    -- Clock process definitions
    I_clk_process :process
    begin
        I_clk <= '0';
        wait for I_clk_period/2;
        I_clk <= '1';
        wait for I_clk_period/2;
    end process;
    
    stim_proc: process
    begin
        -- hold reset state for 100 ns
        wait for 100 ns;
        wait for I_clk_period*10;
        
        -- stimulus
        I_en <= '1';
        
        -- test for writing
        -- r0 = 0xfab5
        I_selA <= "000";
        I_selB <= "001";
        I_selD <= "000";
        I_dataD <= X"FAB5";
        I_we <= '1';
            wait for I_clk_period;
        
        -- r2 = 0x2222
        I_selA <= "000";
        I_selB <= "001";
        I_selD <= "010";
        I_dataD <= X"2222";
        I_we <= '1';
            wait for I_clk_period;
            
        -- r3 = 0x3333
        I_selA <= "000";
        I_selB <= "001";
        I_selD <= "010";
        I_dataD <= X"3333";
        I_we <= '1';
            wait for I_clk_period;
        
        -- test just reading, with no write
        I_selA <= "000";
        I_selB <= "001";
        I_selD <= "000";
        I_dataD <= X"FEED";
        I_we <= '0';
            wait for I_clk_period;
            
        -- At this point dataA should not be 'feed'
        
        I_selA <= "001";
        I_selB <= "010";
            wait for I_clk_period;
        
        I_selA <= "011";
        I_selB <= "100";
            wait for I_clk_period;
        
        I_selA <= "000";
        I_selB <= "001";
        I_selD <= "100";
        I_dataD <= X"4444";
        I_we <= '1';
            wait for I_clk_period;
        
        I_we <= '0';
            wait for I_clk_period;
        
        -- nop
            wait for I_clk_period;
        
        I_selA <= "100";
        I_selB <= "100";
            wait for I_clk_period;
            
            wait;
    end process;

end;
