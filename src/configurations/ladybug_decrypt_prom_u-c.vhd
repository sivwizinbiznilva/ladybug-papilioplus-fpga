-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_decrypt_prom_u-c.vhd,v 1.4 2005/11/15 23:51:43 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_decrypt_prom_u_c0 of ladybug_decrypt_prom_u is

  for struct

    for prom_b : prom_decrypt_u
      use configuration work.prom_decrypt_u_rtl_c0;
    end for;

  end for;

end ladybug_decrypt_prom_u_c0;
