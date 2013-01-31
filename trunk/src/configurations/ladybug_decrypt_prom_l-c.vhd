-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_decrypt_prom_l-c.vhd,v 1.4 2005/11/15 23:51:43 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_decrypt_prom_l_c0 of ladybug_decrypt_prom_l is

  for struct

    for prom_b : prom_decrypt_l
      use configuration work.prom_decrypt_l_rtl_c0;
    end for;

  end for;

end ladybug_decrypt_prom_l_c0;
