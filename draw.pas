program test;
uses crt;
var x,y,o: integer;
    pix: array [0..6000] of word;
    size: integer;
    keyp: boolean;
    key: char;

function Depth ( a: byte ) : char;
  begin
      if a = 1 then
         Depth := '°'
      else if a = 2 then
         Depth := '±'
      else if a = 3 then
         Depth := '²'
      else if a = 4 then
         Depth := 'Û';

  end;

procedure  InsertPixel(x: integer; y:integer; dep:byte);
  begin
     pix[size*3]   := x;
     pix[size*3+1] := y;
     pix[size*3+2] := dep;
     GotoXY(x,y);
     write(Depth(dep));
     GotoXY(x,y);
  end;

procedure DrawPic;
var i:integer;
  begin
      i:=0;
      while i < size*3 do begin
          GotoXY(pix[i],pix[i+1]);
          write(Depth(pix[i+2]));

          i:=i+3;
      end;
  end;

begin
clrscr;
         // H P K M up down left right
    size:=0; // pix[0]:=10; pix[1]:=13; pix[2]:=1;
    x:= 1;
    y:= 1;

    while (key <> 'S') do
    begin

        clrscr;
        //Draws All the pixels
        Textcolor(white);
        DrawPic;
        //Draws Cursor Current Position
        Textcolor(12);
        GotoXY(x,y); write('x'); GotoXY(x,y);


        //Read key
        key := readkey;

        //Prevent cursor out of canvas.
           if (key = 'H') and (y>1)  then y:= y-1;
           if (key = 'P') and (y<25) then y:= y+1;
           if (key = 'K') and (x>1)  then x:= x-1;
           if (key = 'M') and (x<79) then x:= x+1;

        //Drawing blocks
           if key = 'z' then InsertPixel(x,y,1);
           if key = 'x' then InsertPixel(x,y,2);
           if key = 'c' then InsertPixel(x,y,3);
           if key = 'v' then InsertPixel(x,y,4);

           if (key='z') or (key='x') or (key='c') or (key='v') then
           size:=size+1;


    end;

end.