program test;
uses crt;

{consts}
const
    initX  = 35;
    initY  = 3;
    cLeft  = 2;
    cTop   = 2;
    cWidth = 74;
    cHeight= 22;

{main variables}
var x, y, lx, ly: integer;
    pix         : array [0..6900] of byte;
    curcol      : byte;
    size        : integer;
    key         : char;
    lastmsg     : string;

{string to integer}
function sti ( a: string ) : integer;
var i, code: integer;
begin
    val(a,i,code);
    if code = 0 then sti:= i else sti:= 0;
end;

{to string}
function strr ( a: integer ) : string;
var s: string;
begin
    str(a,s);
    strr:= s;
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

function DepthHTML ( a: byte ) : string;
begin
    if a = 1 then
        DepthHTML := '&blk14;'
    else if a = 2 then
        DepthHTML := '&blk12;'
    else if a = 3 then
        DepthHTML := '&blk34;'
    else if a = 4 then
        DepthHTML := '&block;'
    else if a = 0 then
        DepthHTML := '&nbsp;';
end;

procedure DrawBorders;
var i: integer;
begin
    TextColor(white);
    GotoXY(cLeft-1     ,cTop-1);         write(chr(201));
    GotoXY(cLeft+cWidth,cTop-1);         write(chr(187));
    GotoXY(cLeft-1     ,cHeight+cTop);   write(chr(200));
    GotoXY(cLeft+cWidth,cTop+cHeight);   write(chr(188));

    {Top, bottom borders}
    for i:=cLeft to cWidth+1 do begin
      GotoXY(i           , cTop-1);       write(chr(205));
    end;
    for i:=cLeft to cWidth+1 do begin
      GotoXY(i           , cTop+cHeight); write(chr(205));
    end;
    {Left, right borders}
    for i:=cTop  to cHeight+1 do begin
      GotoXY(cLeft-1     , i);            write(chr(186));
    end;
    for i:=cTop  to cHeight+1 do begin
      GotoXY(cLeft+cWidth, i);            write(chr(186));
    end;
end;

procedure DrawColors;
var i: integer;
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

        textcolor(i);  write(chr(219));
        if curcol = i then write(chr(17)) else write(chr(255));
    end;

    Textcolor(white); Textbackground(black);
end;

procedure ChangeColor ( x: integer );
begin
    if (x>0) and (x<16) then curcol:=x;
    DrawColors;
end;

procedure ToCenter ( w: integer; h: integer );
begin
    GotoXY(48-w, 13-h);
end;

procedure WelcomeMessage;
begin
    GotoXY(1,initY+1); textcolor(10); ToCenter(31,8);
    write('.------------------------------.'); ToCenter(31,7);
    write('| Welcome to PascalDraw!       |'); ToCenter(31,6);
    write('| Move around using arrow keys |'); ToCenter(31,5);
    write('| Use ZXCV to draw shades      |'); ToCenter(31,4);
    write('| Press D to erase             |'); ToCenter(31,3);
    write('| Press Shift+D to clear (now!)|'); ToCenter(31,2);
    write('| Press Shift+S to exit.       |'); ToCenter(31,1);
    write('| Shift+I: Open. Shift+O: Save.|'); ToCenter(31,0);
    write('|------------------------------|');
end;

procedure RemovePixel( x: integer; y: integer);
var i, j: integer;
begin
    GotoXY(x,y); write(Depth(0));

    i:=0; 
    while i < size *4 do begin
        if (pix[i]= x-cLeft) and (pix[i+1]=y-cTop) then begin
            {Shifting data}
            for j:=i to size*4-4 do begin
                pix[j] := pix[j+4];
            end;
          i:=i-4;
          size:=size-1;
        end;
        i:=i+4;
    end;
end;

procedure InsertPixel( x: integer; y: integer; dep: byte; col: byte);
begin
     RemovePixel(x,y);
     pix[size*4]   := x-cLeft;
     pix[size*4+1] := y-cTop;
     pix[size*4+2] := dep;
     pix[size*4+3] := col;
     GotoXY(x,y);
     Textcolor(col);
     write(Depth(dep));

     size:= size+1;
end;

procedure DrawPic;
var i: integer;
begin
    i:= 0;
    while i < size*4 do begin

      if (pix[i] = lx-cLeft) and (pix[i+1] = ly-cTop) then begin
          GotoXY( pix[i]+cLeft , pix[i+1]+cTop );
          textcolor(  pix[i+3] );
          write(Depth(pix[i+2]));
      end;

      i:= i+4;
    end;
end;

procedure DrawPicHard;
var i: integer;
begin
    i:= 0;
    while i < size*4 do begin

        GotoXY( pix[i]+cLeft, pix[i+1]+cTop);
        textcolor(  pix[i+3] );
        write(Depth(pix[i+2]));

        i:=i+4;
    end;
end;

procedure MoveCursor( d: integer);
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
var i: integer;
begin
    clrscr;
    DrawBorders;
    DrawColors;
    for i:=0 to size*4 do begin
        pix[i] := 0;
    end;
    size:=0;
end;

procedure Console( s: string );
var i: integer;
begin
    lastmsg:= s;
    GotoXY(1, cHeight+3);
    for i:=1 to 79 do write(chr(255));
    GotoXY(1, cHeight+3); write(s);
end;

procedure RefreshCanvas;
begin
    clrscr; DrawBorders; DrawPicHard; DrawColors; Console(lastmsg);
end;

function FileSz(s: string) : integer;
var f: file of byte; 
    o: integer;
begin
    assign(f,'C:\'+s);
    {$I-} reset(f); {$I+}
    if (IOResult <> 0) then begin
        FileSz:=0;
    end else begin
        o:= filesize(f);
        close(f);
        FileSz:=o;
    end;
end;

procedure OpenCanvas;
var i       : integer;
    f       : text;
    filename: string[32];
    siz     : integer;
    d       : integer;
begin

    TextColor(white);
    Console('Path to open project file: C:\');
    readln(filename);

    if ( FileSz(filename+'.pdr') > 2) or
       ((FileSz(filename)        > 2) and (pos('.pdr',filename) > 0 )) then 
    begin

        if pos('.pdr', filename) > 0 then assign(f, 'C:\'+filename)
                                     else assign(f, 'C:\'+filename+'.pdr');
        {$I-} reset(f); {$I+}
        if (IOResult <> 0) then begin
            textcolor(12);
            Console('File not found... Or it could be some other errors');readln;
        end else begin
            ClearCanvas;
            readln(f,siz);
            textcolor(10);
            Console('Opened project with '+strr(siz)+' drawn pixels. Enter to refresh.');
            
            i:= 0;
            while not eof(f) do begin
              size:= (i div 4) + 1;
              read(f,d);
              pix[i] := d;
              i:=i+1;
            end;
            close(f);
            readln;
       end;

    end else begin
        textcolor(12);
        Console('File is not a PascalDraw file. Choose a .pdr file.');
        readln;
    end;
    RefreshCanvas;
end;

procedure SaveCanvas;
var i       : integer;
    f       : text;
    filename: string[32];
begin

    TextColor(white);
    Console('Path to save project file: C:\'); 
    readln(filename);

    if pos('.pdr',filename) > 0 then delete(filename,pos('.pdr',filename),3);

    assign(f,'C:\'+filename+'.pdr');
    {$I-} rewrite(f); {$I+}
    if (IOResult <> 0) then
    begin

        textcolor(12);
        Console('An error occured. Please file a bug.'); readln;

    end else begin
        writeln(f, size);

        for i:=0 to size*4-1 do begin
            write(f, pix[i]);
            if i <> size*4-1 then write(f,' ');
        end;

        close(f);
        textcolor(10);
        Console('Successfully saved to: C:\'+filename+'.pdr ('+strr(FileSz(filename+'.pdr'))+' bytes)');
        readln;
    end;
    RefreshCanvas;
end;

procedure ExportHtml;
var i, j, k, t: integer;
    f         : text; 
    fn        : string[32];
begin

    Console('Path to export HTML: C:\'); 
    readln(fn);

    if pos('.html',fn) > 0 then delete(fn,pos('.html',fn),3);

    assign(f, 'C:\'+fn+'.html');
    {$I-} rewrite(f); {$I+}

    if (IOResult <> 0) then begin
        textcolor(12);
        Console('Unable to export. Please file a bug.'); readln;
    end else begin
        writeln(f, '<!DOCTYPE HTML5>');
        writeln(f, '<html> <head> <meta charset=''utf-8''> ');
        writeln(f, '<style>');
            writeln(f, '.c   { color:white  }');
            writeln(f, '.c1  { color:navy   } .c2  { color:green  }');
            writeln(f, '.c3  { color:teal   } .c4  { color:maroon }');
            writeln(f, '.c5  { color:purple } .c6  { color:olive  }');
            writeln(f, '.c7  { color:silver } .c8  { color:gray   }');
            writeln(f, '.c9  { color:blue   } .c10 { color:lime   }');
            writeln(f, '.c11 { color:cyan   } .c12 { color:red    }');
            writeln(f, '.c13 { color:magenta} .c14 { color:yellow }');
        writeln(f, '</style>');
        writeln(f, '</head> <body style=''font-family:"Courier","Lucida Console";''>');
        write  (f, '<div style=''background:black; color:white; display:inline-block;');
        writeln(f, 'float:left; border: 4px double white; ''>');

        for i:=0 to cHeight-1 do begin
            for j:=0 to cWidth-1 do begin
            {Looping through every pixel}
                t:=0;
                k:=0;

                while (k < size*4) and (t = 0) do begin
                    if (pix[k] = j) and (pix[k+1] = i) then begin
                        write(f,'<span class="c');
                        write(f,pix[k+3]); write(f,'">');
                        write(f,DepthHTML(pix[k+2]));
                        t:=1;
                    end;

                    k:=k+4;
                end;

                if t=0 then begin
                    write(f,'<span>');
                    write(f,DepthHTML(0));
                end;

                write(f,'</span>');
            end;
           writeln(f,'<br>');
        end;

        writeln(f,'</div></body></html>');

        close(f);
        textcolor(10);
        Console('Succesfully exported to C:\'+fn+'.html ('+strr(FileSz(fn+'.html'))+' bytes)');
        readln;
    end;
  RefreshCanvas;
end;

procedure ConfirmExit;
var reply: string[3];
begin
    TextColor(12);
    Console('All changes will be lost. Are you sure you want to exit (y/n)? ');
    readln(reply);
    if copy(reply,1,1) = 'y' then key := '*' else
    begin
        key:='-';
        Console('Cancelled.');
        RefreshCanvas;
    end;
end;

{ Main }

begin
clrscr;

    {Init vars}
    size  :=0;
    curcol:=15;
    key   :='-';
    x     := InitX;
    y     := InitY;

    {Init procs}
    DrawBorders;
    DrawColors;
    WelcomeMessage;

    while (key <> '*') do
    begin
        { Draws All the pixels}
        DrawPic;

        { Draws Cursor Current Position}
        Textcolor(curcol);
        GotoXY(x,y); write('#'); GotoXY(x,y);

        { Read key}
        key := readkey;

        { Keypresses}
        case key of
          { Exiting }
            'S': ConfirmExit;
          { Cursor moving}
            'H': MoveCursor(1);
            'P': MoveCursor(2);
            'K': MoveCursor(3);
            'M': MoveCursor(4);
          { Shading}
            'z': InsertPixel(x,y,1,curcol);
            'x': InsertPixel(x,y,2,curcol);
            'c': InsertPixel(x,y,3,curcol);
            'v': InsertPixel(x,y,4,curcol);
          { Deleting Pixels}
            'd': InsertPixel(x,y,0,curcol);
          { Clear Canvas}
            'D': ClearCanvas;
          { Open / Save / Export}
            'I': OpenCanvas;
            'O': SaveCanvas;
            'E': ExportHtml;
          { Colors}
            'q': ChangeColor(11);
            'w': ChangeColor(12);
            'e': ChangeColor(13);
            'r': ChangeColor(14);
            't': ChangeColor(15);
            '0': ChangeColor(10);
            else if (sti(key) <10) and (sti(key) > -1 ) then
            ChangeColor( sti(key));
        end;
    end;
end.
