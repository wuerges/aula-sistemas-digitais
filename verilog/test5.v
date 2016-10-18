

module test5;

reg  a, b, c, sa, sb, sc;
wire ta, tb, tc;
wire ua, ub, uc;

wire xa, xb, xc;

wire y;

nor nor1(ta, a, sa);
nor nor2(tb, b, sb);
nor nor3(tc, c, sc);

and and1(ua, a, sa);
and and2(ub, b, sb);
and and3(uc, c, sc);


or or1(xa, ta, ua);
or or2(xb, tb, ub);
or or3(xc, tc, uc);

and f(y, xa, xb, xc);



initial begin
  $dumpvars(0, a, b, c, sa, sb, sc, y);

  #2
  a <= 0 ; b <= 0 ; c <= 0 ;
  sa <= 0; sb <= 0; sc <= 0;
  #2
  a <= 1 ; b <= 0 ; c <= 0 ;
  sa <= 1; sb <= 0; sc <= 0;
  #2
  a <= 0 ; b <= 1 ; c <= 0 ;
  sa <= 0; sb <= 1; sc <= 0;
  #2
  a <= 0 ; b <= 1 ; c <= 0 ;
  sa <= 0; sb <= 0; sc <= 0;
  #2
  a <= 1 ; b <= 0 ; c <= 0 ;
  sa <= 0; sb <= 0; sc <= 0;
  #2
  a <= 1 ; b <= 0 ; c <= 1 ;
  sa <= 1; sb <= 0; sc <= 0;


end

endmodule
