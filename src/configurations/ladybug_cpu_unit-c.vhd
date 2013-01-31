-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_cpu_unit-c.vhd,v 1.5 2005/11/18 23:32:51 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_cpu_unit_struct_c0 of ladybug_cpu_unit is

  for struct

    for T80a_b: T80a
      use configuration work.T80a_rtl_c0;
    end for;

    for use_internal_ram
      for cpu_ram_b: ladybug_cpu_ram
        use configuration work.ladybug_cpu_ram_struct_c0;
      end for;
    end for;

    for addr_dec_b: ladybug_addr_dec
      use configuration work.ladybug_addr_dec_rtl_c0;
    end for;

    for gpio_b: ladybug_gpio
      use configuration work.ladybug_gpio_rtl_c0;
    end for;

    for coin_chutes_b: ladybug_chutes
      use configuration work.ladybug_chutes_rtl_c0;
    end for;

    for decrypt_prom_l_b : ladybug_decrypt_prom_l
      use configuration work.ladybug_decrypt_prom_l_c0;
    end for;

    for decrypt_prom_u_b : ladybug_decrypt_prom_u
      use configuration work.ladybug_decrypt_prom_u_c0;
    end for;

  end for;

end ladybug_cpu_unit_struct_c0;
