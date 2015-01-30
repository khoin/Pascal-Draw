program test;
uses crt;
{consts}
const
    initX = 35;
    initY = 3;
    cLeft = 2;
    cTop  = 2;
    cWidth= 74;
    cHeight=22;

{main variables}
var x,y, lx, ly: integer;
    pix: array [0..6900] of byte;
    curcol: byte;
    size: integer;
    key: char;
    lastmsg: string;

{string to integer}
function sti ( a:string ) : integer;
var i, code: integer;
begin
    val(a,i,code);
    if code = 0 then sti:=i else sti:=0;
end;

{to string}
function strr(a:integer) : string;
var s:string;
begin
    str(a,s);
    strr:=s;
end;

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
procedure DrawBorders;
var i:integer;
begin
    TextColor(white);
    GotoXY(cLeft-1     ,cTop-1);         write(chr(201));
    GotoXY(cLeft+cWidth,cTop-1);         write(chr(187));
    GotoXY(cLeft-1     ,cHeight+cTop);   write(chr(200));
    GotoXY(cLeft+cWidth,cTop+cHeight);   write(chr(188));

    for i:=cLeft to cWidth+1 do begin
      GotoXY(i,cTop-1); write(chr(205));
    end;
    for i:=cLeft to cWidth+1 do begin
      GotoXY(i,cTop+cHeight); write(chr(205));
    end;
    for i:=cTop to cHeight+1 do begin
      GotoXY(cLeft-1,i); write(chr(186));
    end;
    for i:=cTop to cHeight+1 do begin
      GotoXY(cLeft+cWidth,i); write(chr(186));
    end;
end;

procedure DrawColors;
var i:integer;
begin

    for i:=1 to 15 do begin
        textcolor(white);
        GotoXY(cLeft+cWidth+1,i);
        case i of
         10: write('0');
         11: write('q');
         12: write('w');
         13: write('e');
         14: write('r');
         15: write('t');
          else write(i);
        end;

        textcolor(i);     write(chr(219));
        if curcol = i then write(chr(174)) else write(chr(255));
    end;
    Textcolor(white); Textbackground(black);
end;

procedure ChangeColor(x:integer);
begin
    if (x>0) and (x<16) then curcol:=x;
    DrawColors;
end;

procedure ToCenter(w: integer; h: integer);
begin
    GotoXY(48-w, 13-h);
end;

procedure WelcomeMessage;
begin
    GotoXY(1,initY+1); textcolor(10); ToCenter(31,7);
    write('.------------------------------.'); ToCenter(31,6);
    write('| Welcome to PascalDraw!       |'); ToCenter(31,5);
    write('| Move around using arrow keys |'); ToCenter(31,4);
    write('| Use ZXCV to draw shades      |'); ToCenter(31,3);
    write('| Press D to erase             |'); ToCenter(31,2);
    write('| Press Shift+D to clear (now!)|'); ToCenter(31,1);
    write('| Press Shift+S to exit.       |'); ToCenter(31,0);
    write('|------------------------------|');
end;

procedure RemovePixel(x: integer; y:integer);
var i:integer;
    j:integer;
  begin
   GotoXY(x,y); write(Depth(0));

   i:=0;
   while i < size*4 do begin
       if (pix[i]=x) and (pix[i+1]=y) then begin
          {Shifting data}
          for j:=i to size*4-4 do begin
              pix[j] := pix[j+4];
          end;
          size:= size-1;
       end;
       i:=i+4;
   end;
  end;

procedure InsertPixel(x: integer; y:integer; dep:byte; col: byte);
  begin
     RemovePixel(x,y);
     pix[size*4]   := x;
     pix[size*4+1] := y;
     pix[size*4+2] := dep;
     pix[size*4+3] := col;
     GotoXY(x,y);
     Textcolor(curcol);
     write(Depth(dep));

     size:=size+1;
  end;

procedure DrawPic;
var i:integer;
  begin
      i:=0;
      while i < size*4 do begin
         if (pix[i]=lx) and (pix[i+1]=ly) then begin
           GotoXY(pix[i],pix[i+1]);
           textcolor( pix[i+3] );
           write(Depth(pix[i+2]));
         end;
          i:=i+4;
      end;
  end;

procedure DrawPicHard;
var i:integer;
  begin
      i:=0;
      while i < size*4 do begin

           GotoXY(pix[i],pix[i+1]);
           textcolor( pix[i+3] );
           write(Depth(pix[i+2]));

          i:=i+4;
      end;
  end;

procedure MoveCursor(d: integer);
begin
    {Register last cursor coord and clear previous cursor stroke}
    GotoXY(x,y); write(chr(255));
    lx:= x;
    ly:= y;

    if (d=1) and ( y > cTop)           then y:= y-1;
    if (d=2) and ( y < cTop+cHeight-1) then y:= y+1;
    if (d=3) and ( x > cLeft)          then x:= x-1;
    if (d=4) and ( x < cLeft+cWidth-1) then x:= x+1;

end;

procedure ClearCanvas;
var i:integer;
  begin
      clrscr;
      DrawBorders;
      DrawColors;
      for i:=0 to size*4 do begin
          pix[i] := 0;
      end;
      size:=0;
  end;

procedure Console(s:string);
var i:integer;
begin
    lastmsg:=s;
    GotoXY(1,cHeight+3);
    for i:=1 to 79 do write(chr(255));
    GotoXY(1,cHeight+3); write(s);
end;

procedure RefreshCanvas;
begin
    clrscr; DrawBorders; DrawPicHard; DrawColors; Console(lastmsg);
end;

function FileSz(s: string) : integer;
var f: file of byte; o: integer;
begin
    assign(f,'C:\'+s);
    {$I-} reset(f); {$+}
    if (IOResult <> 0) then begin
         FileSz:=0;
        end else begin
        o:= filesize(f);
        close(f);
        FileSz:=o;
        end;
end;

procedure OpenCanvas;
var i:integer;
    f:text;
    filename: string[32];
    siz: integer;
    d: integer;
begin

   Console('Path to open project file: C:\');readln(filename);

   if pos('.pd', filename) > 0 then begin
       assign(f, 'C:\'+filename);
       {$-} reset(f); {$+}
       if (IOResult <> 0) then begin
           textcolor(12);
           Console('File not found... Or it could be some other errors');readln;
       end else begin
           ClearCanvas;
           readln(f,siz);


           textcolor(10);
           Console('Opened project with '+strr(siz)+' drawn pixels. Enter to refresh.');
           i:=0;
           while not eof(f) do begin
              size:= (i div 4)+1;
              read(f,d);
              pix[i] := d;
              i:=i+1;
           end;
           close(f);
           readln;
       end;
   end else begin
       textcolor(12);
       Console('File is not a PascalDraw file. Choose a .dp file.');readln;
   end;
   RefreshCanvas;
end;

procedure SaveCanvas;
var i:integer;
    f: text;
    filename: string[32];
begin
    Console('Path to save project file: C:\'); readln(filename);

    if pos('.pd',filename) > 0 then delete(filename,pos('.pd',filename),3);

    assign(f,'C:\'+filename+'.pd');
    {$I-}
    rewrite(f);
    {$I+}
    if (IOResult <> 0) then
      begin
          textcolor(12);
          Console('An error occured. Please file a bug.'); readln;
      end else
      begin
          writeln(f, size);
          for i:=0 to size*4-1 do begin
              write(f, pix[i]);
              if i <> size*4-1 then write(f,' ');
          end;
          close(f);
          textcolor(10);
          Console('Successfully saved to: C:\'+filename+'.pd ('+strr(FileSz(filename+'.pd'))+' bytes)');


          readln;
      end;
    RefreshCanvas;
end;

{Main }


begin
clrscr;

    size:=0;
    curcol:=15;
    x:= InitX;
    y:= InitY;
    DrawBorders;
    DrawColors;
    WelcomeMessage;

    while (key <> 'S') do
    begin

        {//Draws All the pixels}
        Textcolor(white);
        DrawPic;
        //Draws Cursor Current Position
        Textcolor(curcol);
        GotoXY(x,y); write('#'); GotoXY(x,y);


        {//Read key}
        key := readkey;

        {//Moving Cursor}
           if (key = 'H') then MoveCursor(1);
           if (key = 'P') then MoveCursor(2);
           if (key = 'K') then MoveCursor(3);
           if (key = 'M') then MoveCursor(4);

        {//Drawing blocks}
           if key = 'z' then InsertPixel(x,y,1,curcol);
           if key = 'x' then InsertPixel(x,y,2,curcol);
           if key = 'c' then InsertPixel(x,y,3,curcol);
           if key = 'v' then InsertPixel(x,y,4,curcol);

        {//Deleting block}
           if key = 'd' then InsertPixel(x,y,0,curcol);

        {//Colors}
           case key of
               'q': ChangeColor(11);
               'w': ChangeColor(12);
               'e': ChangeColor(13);
               'r': ChangeColor(14);
               't': ChangeColor(15);
               '0': ChangeColor(10);
               else if abs( sti(key)-5) <6 then
               ChangeColor( sti(key));
           end;

        {//Utils}
           if key = 'D' then ClearCanvas;

        {// File I/O}
           if key = 'I' then OpenCanvas;
           if key = 'O' then SaveCanvas;

    end;

end.
