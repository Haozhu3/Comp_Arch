// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    
    wire na,nb,nc0,nc1,nanbc1nc0,nabnc1c0,nabc1c0,anbnc1c0,anbc0c1,abnc0nc1,abnc1c0;
    not n1(na,A);
    not n2(nb,B);
    not n3(nc0,control[0]);    
    not n4(nc1,control[1]);
    
    and a1(nanbc1nc0,na,nb,control[1],nc0);
    and a2(nabnc1c0,na,B,control[0],nc1);
    and a3(nabc1c0,na,B,control[0],control[1]);
    and a4(anbnc1c0,A,nb,control[0],nc1);
    and a5(anbc0c1,A,nb,control[0],control[1]);
    and a6(abnc0nc1,A,B,nc1,nc0);
    and a7(abnc1c0,A,B,control[0],nc1);         
    
    or(out,nabc1c0,nabnc1c0,nanbc1nc0,anbc0c1,anbnc1c0,abnc0nc1,abnc1c0);   
    
    
endmodule // logicunit
