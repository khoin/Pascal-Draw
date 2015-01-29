program test;
uses crt;
{consts}
const
    initX = 35;
    initY = 10;
    cWidth= 79;
    cHeight=23;

{main variables}
var x,y, lx, ly: integer;
    pix: array [0..6000] of word;
    size: integer;
    keyp: boolean;
    key: char;

function Depth ( a: byte ) : char;
  begin
      if a = 1 then
         Depth := chr(176)
      else if a = 2 then
         Depth := chr(177)
      else if a = 3 then
         Depth := chr(178)
      else if a = 4 then
         Depth := chr(219)
      else if a = 0 then
         Depth := chr(255);

  end;

procedure WelcomeMessage;
begin
    GotoXY(1,initY+1); textcolor(10);
    writeln('.------------------------------.');
    writeln('| Welcome to PascalDraw!       |');
    writeln('| Move around using arrow keys |');
    writeln('| Use ZXCV to draw shades      |');
    writeln('| Press Shift+D to clear (now!)|');
    writeln('| Press Shift+C to exit.       |');
    writeln('|------------------------------|');
end;

procedure RemovePixel(x: integer; y:integer);
var i:integer;
    j:integer;
  begin
   GotoXY(x,y); write(Depth(0));

   i:=0;
   while i < size*3 do begin
       if (pix[i]=x) and (pix[i+1]=y) then begin
          {Shifting data}
          for j:=i to size*3-3 do begin
              pix[j] := pix[j+3];
          end;
          size:= size-1;
       end;
       i:=i+3;
   end;
  end;

procedure InsertPixel(x: integer; y:integer; dep:byte);
  begin
     pix[size*3]   := x;
     pix[size*3+1] := y;
     pix[size*3+2] := dep;
     GotoXY(x,y);
     write(Depth(dep));

     size:=size+1;
  end;

procedure DrawPic;
var i:integer;
  begin
      i:=0;
      while i < size*3 do begin
         if (pix[i]=lx) and (pix[i+1]=ly) then begin
           GotoXY(pix[i],pix[i+1]);
           write(Depth(pix[i+2]));
         end;
          i:=i+3;
      end;
  end;

procedure MoveCursor(d: integer);
begin
    {Register last cursor coord and clear previous cursor stroke}
    GotoXY(x,y); write(chr(255));
    lx:= x;
    ly:= y;

    if (d=1) and (y>1)  then y:= y-1;
    if (d=2) and (y<cHeight) then y:= y+1;
    if (d=3) and (x>1)  then x:= x-1;
    if (d=4) and (x<cWidth) then x:= x+1;

end;

procedure ClearCanvas;
var i:integer;
  begin
      clrscr;
      for i:=0 to size*3 do begin
          pix[i] := 0;
      end;
      size:=0;
  end;


{Main }


begin
clrscr;

    size:=0;
    x:= InitX;
    y:= InitY;
    WelcomeMessage;

    while (key <> 'S') do
    begin


        {//Draws All the pixels}
        Textcolor(white);
        DrawPic;
        //Draws Cursor Current Position
        Textcolor(12);
        GotoXY(x,y); write('x'); GotoXY(x,y);


        {//Read key}
        key := readkey;

        {//Moving Cursor}
           if (key = 'H') then MoveCursor(1);
           if (key = 'P') then MoveCursor(2);
           if (key = 'K') then MoveCursor(3);
           if (key = 'M') then MoveCursor(4);

        {//Drawing blocks}
           if key = 'z' then InsertPixel(x,y,1);
           if key = 'x' then InsertPixel(x,y,2);
           if key = 'c' then InsertPixel(x,y,3);
           if key = 'v' then InsertPixel(x,y,4);

        {//Deleting block}
           if key = 'd' then InsertPixel(x,y,0);



        {//Utils}
           if key = 'D' then ClearCanvas;

    end;

end.
