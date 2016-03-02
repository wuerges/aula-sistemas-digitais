
module Values(
    input i_one,
    input i_zero,
    input i_unk,
    input i_imp,
    output v_zero,
    output v_one,
    output v_unknown_1,
    output v_unknown_2,
    output v_unknown_3,
    output v_unknown_4,
    output v_imp_1,
    output v_imp_2,
    output v_imp_3,
    output v_imp_4
  );

  assign v_one = i_one;
  assign v_zero = i_zero;
  assign v_unknown_1 = i_unk;
  assign v_unknown_2 = i_unk & i_one;
  assign v_unknown_3 = i_unk & i_zero;
  assign v_unknown_4 = i_unk & i_imp;
  assign v_imp_1 = i_imp;
  assign v_imp_2 = i_imp & i_one;
  assign v_imp_3 = i_imp & i_zero;
  assign v_imp_4 = i_imp & i_unk;

endmodule

module test;

  reg i_one
    , i_zero
    , i_unk
    , i_imp;
  wire v_zero
     , v_one
     , v_unknown_1
     , v_unknown_2
     , v_unknown_3
     , v_unknown_4
     , v_imp_1
     , v_imp_2
     , v_imp_3
     , v_imp_4;

  Values V(i_one
         , i_zero
         , i_unk
         , i_imp
         , v_zero
         , v_one
         , v_unknown_1
         , v_unknown_2
         , v_unknown_3
         , v_unknown_4
         , v_imp_1
         , v_imp_2
         , v_imp_3
         , v_imp_4
         );
  
  initial begin
    $dumpvars(0, V);
    #10;
    i_one <=  1'b1;
    i_zero <= 1'b0;
    i_unk <=  1'bx;
    i_imp <=  1'bz;
    #500;
    $finish;
  end
endmodule
