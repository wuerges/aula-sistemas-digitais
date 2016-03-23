
//def sign(p1, p2, p3):
//    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);


//def sign(p1, p2, p3):
//    t1 = p1.x - p3.x
//    t2 = p2.y - p3.y
//    t3 = p2.x - p3.x
//    t4 = p1.y - p3.y
//    m1 = t1 * t2;
//    m2 = t3 * t4;
//    r =  m1 - m2;
//    return r


module sign(
  input [10:0] p1x,
  input [10:0] p1y,
  input [10:0] p2x,
  input [10:0] p2y,
  input [10:0] p3x,
  input [10:0] p3y,
  output s
);

  wire signed [11:0] t1;
  wire signed [11:0] t2;
  wire signed [11:0] t3;
  wire signed [11:0] t4;
  wire signed [23:0] m1;
  wire signed [23:0] m2;

  assign t1 = p1x - p3x;
  assign t2 = p2y - p3y;
  assign t3 = p2x - p3x;
  assign t4 = p1y - p3y;

  assign m1 = t1 * t2;
  assign m2 = t3 * t4;

  assign s = m1 < m2;

endmodule

module triangle(
  input [10:0] ptx,
  input [10:0] pty,
  input [10:0] p1x,
  input [10:0] p1y,
  input [10:0] p2x,
  input [10:0] p2y,
  input [10:0] p3x,
  input [10:0] p3y,
  output inside
);


wire s1, s2, s3; 

sign S1(ptx, pty, p1x, p1y, p2x, p2y, s1);
sign S2(ptx, pty, p2x, p2y, p3x, p3y, s2);
sign S3(ptx, pty, p3x, p3y, p1x, p1y, s3);


assign inside = s1 == s2 & s2 == s3;

endmodule
