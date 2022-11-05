library ieee;
use ieee.std_logic_1164.all;

entity sum_tb is
end sum_tb;

architecture tb of sum_tb is

    component top_artya7_100
        port (IO_CLK     : in std_logic;
              IO_RST_N  : in std_logic
              );
    end component;

    signal IO_CLK     : std_logic := '0';
    signal IO_RST_N  : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here

begin    dut : top_artya7_100
    port map (IO_CLK     => IO_CLK,
              IO_RST_N  => IO_RST_N
             );

    -- Clock generation
    IO_CLK <= not IO_CLK after TbPeriod/2;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset_rtl_0_0 is really your reset signal
        IO_RST_N <= '0';
        wait for 2*TbPeriod;
        
        IO_RST_N <= '1';
        wait for 2*TbPeriod;

        -- EDIT Add stimuli here
        
        wait;
    end process;

end tb;
