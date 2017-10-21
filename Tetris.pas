{Kacper Szalwa}
program Tetris;
{$APPTYPE GUI} {WYLACZA OKNO KONSOLOWE WINDOWSA !!!}

uses allegro, dos;

const
  ScreenWidth = 1020;
  ScreenHeight = 800;
  skala = 40;

type klocki = record
posX : integer;
posY : integer;
indeks : integer;
stan : integer;
end;

type gracz_wynik = record
nick_gracza : string;
wynik : integer;
end;

var warunek : boolean;
var main_picture, menu, podglad_klocka, wynik_gracza, highscore, game_over, bmp, bmp_tmp, author, level_bmp: ^AL_BITMAP;
var music : ^AL_SAMPLE;
var myfont, myfont2, myfont3, myfont4 : AL_FONTptr;
var speed, tempo, numbers_of_deleted_lines, tmp_indeks, wynik, wynik_tmp, level, speed2: integer;
var main_tab : array [0..21, 0..11] of integer;
var next_klocek : array [1..4, 1..4] of integer;
var siatka : array [1..4, 1..4] of boolean;
var siatka_tmp : array [1..4, 1..4] of boolean;
var klocek : klocki;
var tab_wynikow : array [1..11] of gracz_wynik;

procedure siatka_klocka(id_klocka : integer; stan_klocka : integer);
var i, j : integer;
begin
    for i := 1 to 4 do
    begin
       for j := 1 to 4 do
       begin
          siatka[i, j] := false;
       end;
    end;
    case id_klocka of
    1:
      begin
           siatka[1, 2] := true;
           siatka[1, 3] := true;
           siatka[2, 2] := true;
           siatka[2, 3] := true;
      end;
    2:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 3] := true;
                siatka[2, 3] := true;
                siatka[3, 2] := true;
                siatka[3, 3] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[1, 2] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
                siatka[2, 4] := true;
           end
           else
           if(stan_klocka = 3) then
           begin
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[2, 2] := true;
                siatka[3, 2] := true;
           end
           else
           if(stan_klocka = 4) then
           begin
                siatka[1, 1] := true;
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[2, 3] := true;
           end;
      end;
    3:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 2] := true;
                siatka[2, 2] := true;
                siatka[3, 2] := true;
                siatka[3, 3] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[1, 4] := true;
                siatka[2, 2] := true;
           end
           else
           if(stan_klocka = 3) then
           begin
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[2, 3] := true;
                siatka[3, 3] := true;
           end
           else
           if(stan_klocka = 4) then
           begin
                siatka[1, 3] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
           end;
      end;
    4:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 1] := true;
                siatka[1, 2] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[1, 2] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[3, 1] := true;
           end;
      end;
    5:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[1, 1] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[3, 2] := true;
           end;
      end;
    6:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 2] := true;
                siatka[2, 2] := true;
                siatka[3, 2] := true;
                siatka[4, 2] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
                siatka[2, 4] := true;
           end;
      end;
    7:
      begin
           if(stan_klocka = 1) then
           begin
                siatka[1, 2] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
           end
           else
           if(stan_klocka = 2) then
           begin
                siatka[1, 2] := true;
                siatka[2, 2] := true;
                siatka[2, 3] := true;
                siatka[3, 2] := true;
           end
           else
           if(stan_klocka = 3) then
           begin
                siatka[1, 1] := true;
                siatka[1, 2] := true;
                siatka[1, 3] := true;
                siatka[2, 2] := true;
           end
           else
           if(stan_klocka = 4) then
           begin
                siatka[1, 2] := true;
                siatka[2, 1] := true;
                siatka[2, 2] := true;
                siatka[3, 2] := true;
           end;
      end;
    end;
end;

procedure rysuj_siatke_na_planszy(id_klocka : integer; stan_klocka : integer; posY : integer; posX : integer);
var i, j : integer;
begin
    siatka_klocka(id_klocka, stan_klocka);
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              main_tab[posY + i, posX + j] := id_klocka;
         end;
    end;
end;

procedure rysuj_siatke_do_podgladu_next_klocka(id_klocka : integer);
var i, j : integer;
begin
     for i := 1 to 4 do
     begin
          for j := 1 to 4 do
          begin
               next_klocek[i, j] := 0;
          end;
     end;
     siatka_klocka(id_klocka, 1);
     for i := 1 to 4 do
     begin
          for j := 1 to 4 do
          begin
               if(siatka[i, j]) then
               next_klocek[i, j] := id_klocka;
          end;
     end;
end;

function czy_mozna_opuscic(id_klocka : integer; stan_klocka : integer; posY : integer; posX : integer) : boolean;
var i, j : integer;
begin
    siatka_klocka(id_klocka, stan_klocka);
    czy_mozna_opuscic := false;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              begin
                   if((main_tab[posY + i + 1, posX + j] = 0) or ((main_tab[posY + i + 1, posX + j] = id_klocka) and siatka[i + 1, j] and (i < 4))) then
                   begin
                        czy_mozna_opuscic := true;
                   end
                   else
                   begin
                        czy_mozna_opuscic := false;
                        exit;
                   end;
              end;
         end;
    end;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              begin
                   main_tab[posY + i, posX + j] := 0;
              end;
         end;
    end;
end;

function czy_mozna_w_bok(id_klocka : integer; stan_klocka : integer; posY : integer; posX : integer; strona : integer) : boolean; {lewo = -1, prawo = 1}
var i, j : integer;
begin
    siatka_klocka(id_klocka, stan_klocka);
    czy_mozna_w_bok := false;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              begin
                   if((main_tab[posY + i, posX + j + strona] = 0) or ((main_tab[posY + i, posX + j + strona] = id_klocka) and siatka[i, j + strona])) then
                   begin
                        czy_mozna_w_bok := true;
                   end
                   else
                   begin
                        czy_mozna_w_bok := false;
                        exit;
                   end;
              end;
         end;
    end;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              begin
                   main_tab[posY + i, posX + j] := 0;
              end;
         end;
    end;
end;

function czy_mozna_obrocic(id_klocka : integer; stan_klocka : integer; posY : integer; posX : integer) : boolean;
var i, j : integer;
begin
    siatka_klocka(id_klocka, stan_klocka);
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              siatka_tmp[i, j] := siatka[i, j];
         end;
    end;
    case id_klocka of
    2:
    begin
         if(stan_klocka <> 4) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    3:
    begin
         if(stan_klocka <> 4) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    4:
    begin
         if(stan_klocka <> 2) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    5:
    begin
         if(stan_klocka <> 2) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    6:
    begin
         if(stan_klocka <> 2) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    7:
    begin
         if(stan_klocka <> 4) then inc(stan_klocka)
         else stan_klocka := 1;
    end;
    end;
    siatka_klocka(id_klocka, stan_klocka);
    czy_mozna_obrocic := false;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka[i, j]) then
              begin
                   if((main_tab[posY + i, posX + j] = 0) or ((main_tab[posY + i, posX + j] = id_klocka) and siatka_tmp[i, j])) then
                   begin
                        czy_mozna_obrocic := true;
                   end
                   else
                   begin
                        czy_mozna_obrocic := false;
                        exit;
                   end;
              end;
         end;
    end;
    for i := 1 to 4 do
    begin
         for j := 1 to 4 do
         begin
              if(siatka_tmp[i, j]) then
              begin
                   main_tab[posY + i, posX + j] := 0;
              end;
         end;
    end;
end;

procedure delete_full_line();
var i, j, it1, it2, counter : integer; {it1 i it2 to pomocnicze iteratory}
begin
     for i := 1 to 20 do
     begin
          counter := 0;
          for j := 1 to 10 do
          begin
               if(main_tab[i, j] <> 0) then inc(counter)
               else break;
          end;
          if(counter = 10) then
          begin
               wynik := wynik + 100;
               inc(numbers_of_deleted_lines);
               if(((numbers_of_deleted_lines mod 5) = 0) and (numbers_of_deleted_lines <= 15)) then
               begin
                    inc(tempo);
                    inc(level);
               end;
               for it1 := i downto 2 do
               begin
                    for it2 := 1 to 10 do
                    begin
                         main_tab[it1, it2] := main_tab[it1 - 1, it2];
                    end;
               end;
          end;
     end;
end;

function wylosuj_klocek() : integer; {zwraca indeks_klocka}
begin
    wylosuj_klocek := random(7) + 1;
end;

procedure obroc_klocek();
begin
    case klocek.indeks of
    2:
    begin
         if(klocek.stan <> 4) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    3:
    begin
         if(klocek.stan <> 4) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    4:
    begin
         if(klocek.stan <> 2) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    5:
    begin
         if(klocek.stan <> 2) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    6:
    begin
         if(klocek.stan <> 2) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    7:
    begin
         if(klocek.stan <> 4) then inc(klocek.stan)
         else klocek.stan := 1;
    end;
    end;
end;

function THE_END() : boolean;
var i : integer;
begin
    THE_END := false;
    for i := 1 to 10 do
    begin
         if(main_tab[1, i] <> 0) then
         begin
              THE_END := true;
              game_over := NIL;
              game_over := al_create_bitmap(ScreenWidth, ScreenHeight);
              if(game_over = NIL) then
              begin
                   al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
                   al_message('Nie mogę utworzyć pola game over!');
                   al_exit();
              end;
              break;
         end;
    end;
end;

procedure increment_speed cdecl;
begin
     inc(speed);
end;

procedure increment_speed2 cdecl;
begin
     inc(speed2);
end;

procedure quicksort(left : integer; right : integer); {do sortowania highscore}
var pivot : integer; {os obrotu}
var pivot_str, tmp_str : string;
var tmp, i, j : integer;
begin
    i := ((left + right) div 2);
    pivot := tab_wynikow[i].wynik;
    pivot_str := tab_wynikow[i].nick_gracza;
    tab_wynikow[i].wynik := tab_wynikow[right].wynik;
    tab_wynikow[i].nick_gracza := tab_wynikow[right].nick_gracza;
    j := left;
    for i := left to (right - 1) do
    begin
      if(tab_wynikow[i].wynik < pivot) then
      begin
        tmp := tab_wynikow[i].wynik;
        tmp_str := tab_wynikow[i].nick_gracza;
        tab_wynikow[i].wynik := tab_wynikow[j].wynik;
        tab_wynikow[i].nick_gracza := tab_wynikow[j].nick_gracza;
        tab_wynikow[j].wynik := tmp;
        tab_wynikow[j].nick_gracza := tmp_str;
        inc(j);
      end;
    end;
    tab_wynikow[right].wynik := tab_wynikow[j].wynik;
    tab_wynikow[right].nick_gracza := tab_wynikow[j].nick_gracza;
    tab_wynikow[j].wynik := pivot;
    tab_wynikow[j].nick_gracza := pivot_str;
    if((j - 1) > left) then quicksort(left, j - 1);
    if((j + 1) < right) then quicksort(j + 1, right);
end;

procedure zapis_do_highscore(filename : string; nick : string);
var uchwyt : text;
var i : integer;
var s_tmp : string;
begin
     if(fsearch(filename, '') = '') then
     begin
          assign(uchwyt, filename);
          rewrite(uchwyt);
          close(uchwyt);
     end;
     assign(uchwyt, filename);
     reset(uchwyt);
     i := 1;
     while (not eof(uchwyt)) do
     begin
          readln(uchwyt, s_tmp);
          val(s_tmp, tab_wynikow[i].wynik);
          readln(uchwyt, s_tmp);
          tab_wynikow[i].nick_gracza := s_tmp;
          inc(i);
     end;
     if(i < 11) then
     begin
          for i := i to 10 do
          begin
               tab_wynikow[i].wynik := 0;
               tab_wynikow[i].nick_gracza := '-----';
          end;
     end;
     close(uchwyt);
     tab_wynikow[11].wynik := wynik;
     tab_wynikow[11].nick_gracza := nick;
     quicksort(1, 11);
     assign(uchwyt, filename);
     rewrite(uchwyt);
     for i := 11 downto 2 do
     begin
          writeln(uchwyt, tab_wynikow[i].wynik);
          writeln(uchwyt, tab_wynikow[i].nick_gracza);
     end;
     close(uchwyt);
end;

procedure odczyt_z_highscore(filename : string);
var uchwyt : text;
var str_tmp, str_tmp2, str_tmp3 : string;
var i, j : integer;
begin
     if(fsearch(filename, '') = '') then
     begin
          assign(uchwyt, filename);
          rewrite(uchwyt);
          close(uchwyt);
     end;
     assign(uchwyt, filename);
     reset(uchwyt);
     highscore := NIL;
     highscore := al_create_bitmap(ScreenWidth, ScreenHeight);
     if(highscore = NIL) then
     begin
          al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
          al_message('Nie mogę utworzyć bitmapy highscore!');
          al_exit();
     end;
     i := 1;
     while (not eof(uchwyt)) do
     begin
          readln(uchwyt, str_tmp2);
          val(str_tmp2, tab_wynikow[i].wynik);
          readln(uchwyt, str_tmp3);
          tab_wynikow[i].nick_gracza := str_tmp3;
          inc(i);
     end;
     if(i > 1) then dec(i);
     if(i < 11) then
     begin
          for i := i to 11 do
          begin
               tab_wynikow[i].wynik := 0;
               tab_wynikow[i].nick_gracza := '-----';
          end;
     end;
     close(uchwyt);
     assign(uchwyt, filename);
     reset(uchwyt);
     i := 1;
     while (not eof(uchwyt)) do
     begin
          readln(uchwyt, str_tmp2);
          val(str_tmp2, tab_wynikow[i].wynik);
          readln(uchwyt, str_tmp3);
          tab_wynikow[i].nick_gracza := str_tmp3;
          inc(i);
     end;
     al_textout_centre_ex(highscore, myfont4, 'HIGHSCORE', ScreenWidth div 2, 50, al_makecol(164,46,64), -1);
     j := 1;
     for i := 1 to 10 do
     begin
          str(j, str_tmp2);
          str(tab_wynikow[i].wynik, str_tmp3);
          str_tmp := str_tmp2 + '. ' + tab_wynikow[i].nick_gracza + '      ' + str_tmp3;
          al_textout_ex(highscore, myfont4, str_tmp, 50, 50 * (j + 2), al_makecol(164,46,64), -1);
          inc(j);
     end;
     close(uchwyt);
end;

function otworz_menu() : boolean;
var czy_menu : boolean;
var ktora_opcja_z_menu, i, j : integer;
begin
     otworz_menu := true;
     czy_menu := true;
     menu := NIL;
     menu := al_create_bitmap(ScreenWidth, ScreenHeight);
     myfont := al_load_font('czcionka_do_menu.pcx', NIL, NIL);
     if(myfont = NIL) then al_message('Nie mogę załadowac czcionki!');
     myfont4 := al_load_font('czcionka_do_highscore.pcx', NIL, NIL);
     if(myfont4 = NIL) then al_message('Nie mogę załadowac czcionki!');
     if(menu = NIL) then
     begin
          al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
          al_message('Nie mogę utworzyć menu!');
          al_exit();
     end;
     author := NIL;
     author := al_create_bitmap(ScreenWidth, ScreenHeight);
     if(author = NIL) then
     begin
          al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
          al_message('Nie mogę utworzyć planszy!');
          al_exit();
     end;
     ktora_opcja_z_menu := 1;
     while(czy_menu) do
     begin
          al_textout_centre_ex(menu, myfont, 'Start', ScreenWidth div 2, (ScreenHeight div 3) - 150, al_makecol(164,46,64), -1);
          al_textout_centre_ex(menu, myfont, 'Highscore', ScreenWidth div 2, (ScreenHeight div 3), al_makecol(164,46,64), -1);
          al_textout_centre_ex(menu, myfont, 'Author', ScreenWidth div 2, (ScreenHeight div 3) + 150, al_makecol(164,46,64), -1);
          al_textout_centre_ex(menu, myfont, 'Exit', ScreenWidth div 2, (ScreenHeight div 3) + 300, al_makecol(164,46,64), -1);
          case ktora_opcja_z_menu of
          1:
          begin
               al_rect(menu, (ScreenWidth div 3) + 45, (ScreenHeight div 3) - 150, (ScreenWidth div 3) + 300, (ScreenHeight div 3) - 50, al_makecol(255, 255, 255));
          end;
          2:
          begin
               al_rect(menu, (ScreenWidth div 3) - 28, (ScreenHeight div 3) , (ScreenWidth div 3) + 375, (ScreenHeight div 3) + 100, al_makecol(255, 255, 255));
          end;
          3:
          begin
               al_rect(menu, (ScreenWidth div 3) + 28, (ScreenHeight div 3) + 150, (ScreenWidth div 3) + 320, (ScreenHeight div 3) + 250, al_makecol(255, 255, 255));
          end;
          4:
          begin
               al_rect(menu, (ScreenWidth div 3) + 65, (ScreenHeight div 3) + 300, (ScreenWidth div 3) + 280, (ScreenHeight div 3) + 400, al_makecol(255, 255, 255));
          end;
          end;
          al_blit(menu, al_screen, 0, 0, 0, 0, menu^.w, menu^.h);
          al_clear_to_color (menu, al_makecol(0, 0, 0));
          if(al_key[AL_KEY_DOWN]) then
          begin
               if(ktora_opcja_z_menu < 4) then inc(ktora_opcja_z_menu);
               al_rest(120);
          end;
          if(al_key[AL_KEY_UP]) then
          begin
               if(ktora_opcja_z_menu > 1) then dec(ktora_opcja_z_menu);
               al_rest(120);
          end;
          if(al_key[AL_KEY_ENTER] and (ktora_opcja_z_menu = 1)) then
          begin
               for i := 0 to 21 do
               begin
                    for j := 0 to 11 do
                    begin
                         if((j = 0) or (j = 11) or (i = 21)) then
                         main_tab[i, j] := -1
                         else
                         main_tab[i, j] := 0;
                    end;
               end;
               for i := 1 to 4 do
               begin
                    for j := 1 to 4 do
                    begin
                         next_klocek[i, j] := 0;
                    end;
               end;
               warunek := false;
               klocek.posY := -1;
               klocek.posX := 3;
               klocek.stan := 1;
               klocek.indeks := wylosuj_klocek();
               rysuj_siatke_na_planszy(klocek.indeks, 1, -1, 3);
               tmp_indeks := 0;
               wynik := 0;
               wynik_tmp := 0;
               czy_menu := false;
               tempo := 3;
               level := 1;
               numbers_of_deleted_lines := 0;
               al_install_int_ex(@increment_speed, AL_BPS_TO_TIMER(tempo));
               al_install_int_ex(@increment_speed2, AL_BPS_TO_TIMER(8));
          end
          else if (al_key[AL_KEY_ENTER] and (ktora_opcja_z_menu = 2)) then
          begin
               odczyt_z_highscore('highscore.txt');
               while(not al_key[AL_KEY_ESC]) do
               al_blit(highscore, al_screen, 0, 0, 0, 0, highscore^.w, highscore^.h);
          end
          else if (al_key[AL_KEY_ENTER] and (ktora_opcja_z_menu = 3)) then
          begin
               al_textout_ex(author, myfont3, 'autorem', 50, 50, al_makecol(164,46,64), -1);
               al_textout_ex(author, myfont3, 'gry', 50, 150, al_makecol(164,46,64), -1);
               al_textout_ex(author, myfont3, 'tetris', 50, 250, al_makecol(164,46,64), -1);
               al_textout_ex(author, myfont3, 'jest', 50, 350, al_makecol(164,46,64), -1);
               al_textout_ex(author, myfont3, 'kacper', 50, 450, al_makecol(164,46,64), -1);
               al_textout_ex(author, myfont3, 'szalwa', 50, 550, al_makecol(164,46,64), -1);
               while(not al_key[AL_KEY_ESC]) do
               al_blit(author, al_screen, 0, 0, 0, 0, author^.w, author^.h);
          end
          else if(al_key[AL_KEY_ENTER] and (ktora_opcja_z_menu = 4)) then
          begin
               otworz_menu := false;
               czy_menu := false
          end;
     end;
end;

function initation() : boolean;
var i, j : integer;
begin
randomize;
initation := true;
al_init();
al_install_keyboard();
al_set_color_depth(32);
al_set_window_title('Tetris');
al_set_gfx_mode(AL_GFX_AUTODETECT_WINDOWED,ScreenWidth,ScreenHeight,0,0);
al_clear_to_color (al_screen, al_makecol(0, 0, 0));
myfont2 := al_load_font('czcionka_do_wyniku.pcx', NIL, NIL);
if(myfont2 = NIL) then al_message('Nie mogę załadowac czcionki!');
myfont3 := al_load_font('czcionka_do_napisow.pcx', NIL, NIL);
if(myfont3 = NIL) then al_message('Nie mogę załadowac czcionki!');
if(not otworz_menu()) then
begin
     initation := false;
     al_exit();
     exit();
end;
speed := 0;
al_install_timer();
al_install_sound(AL_DIGI_AUTODETECT, AL_MIDI_AUTODETECT);
al_set_volume(255, 255);
music := al_load_sample('muzyczka_do_tetrisa.wav');
al_play_sample(music, 255, 127, 1000, true);
for i := 0 to 21 do
begin
    for j := 0 to 11 do
    begin
        if((j = 0) or (j = 11) or (i = 21)) then
        main_tab[i, j] := -1
        else
        main_tab[i, j] := 0;
    end;
end;
for i := 1 to 4 do
begin
    for j := 1 to 4 do
    begin
        next_klocek[i, j] := 0;
    end;
end;
warunek := false;
main_picture := NIL;
main_picture := al_create_bitmap(400, ScreenHeight);
if(main_picture = NIL) then
begin
     al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
     al_message('Nie mogę utworzyć planszy!');
     al_exit();
end;
bmp := NIL;
bmp := al_load_bmp('plansza.bmp', @al_default_palette);
if(bmp = NIL) then
begin
     al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
     al_message('Nie mogę utworzyć planszy!');
     al_exit();
end;
bmp_tmp := NIL;
bmp_tmp := al_load_bmp('plansza.bmp', @al_default_palette);
if(bmp_tmp = NIL) then
begin
     al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
     al_message('Nie mogę utworzyć planszy!');
     al_exit();
end;
level_bmp := NIL;
level_bmp := al_create_bitmap(250, 250);
podglad_klocka := NIL;
podglad_klocka := al_create_bitmap(150, 300);
if(podglad_klocka = NIL) then
begin
     al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
     al_message('Nie mogę utworzyć podglądu następnego klocka!');
     al_exit();
end;
wynik_gracza := NIL;
wynik_gracza := al_create_bitmap(250, 150);
if(wynik_gracza = NIL) then
begin
     al_set_gfx_mode(AL_GFX_TEXT, 0, 0, 0, 0);
     al_message('Nie mogę utworzyć podglądu wyniku gracza!');
     al_exit();
end;
al_clear_to_color(main_picture, al_makecol(255, 0, 255));
klocek.posY := -1;
klocek.posX := 3;
klocek.stan := 1;
klocek.indeks := wylosuj_klocek();
rysuj_siatke_na_planszy(klocek.indeks, 1, -1, 3);
tmp_indeks := 0;
wynik := 0;
wynik_tmp := 0;
end;

procedure drawing();
var i, j: integer;
var s_wynik : string;
begin
     al_masked_blit(main_picture, bmp, 0, 0, 0, 0, main_picture^.w, main_picture^.h);
     al_blit(bmp, al_screen, 0, 0, 310, 0, bmp^.w, bmp^.h);
     al_blit(podglad_klocka, al_screen, 0, 0, ScreenWidth - 220, 200, podglad_klocka^.w, podglad_klocka^.h);
     al_blit(wynik_gracza, al_screen, 0, 0, 30, 150, wynik_gracza^.w, wynik_gracza^.h);
     al_blit(bmp_tmp, bmp, 0, 0, 0, 0, bmp_tmp^.w, bmp_tmp^.h);
     al_clear_to_color(main_picture, al_makecol(255, 0, 255));
     al_clear_to_color(podglad_klocka, al_makecol(0, 0, 0));
     al_clear_to_color(wynik_gracza, al_makecol(0, 0, 0));
     al_textout_centre_ex(al_screen, myfont3, 'next', 867, 50, al_makecol(164,46,64), -1);
     al_textout_centre_ex(al_screen, myfont3, 'score', 153, 50, al_makecol(164,46,64), -1);
     str(wynik, s_wynik);
     al_textout_centre_ex(wynik_gracza, myfont2, s_wynik, 125, 40, al_makecol(164,46,64), -1);
     if(level = 1) then
     begin
          al_clear_to_color(level_bmp, al_makecol(0, 0, 0));
          al_textout_centre_ex(level_bmp, myfont3, 'LEVEL', 125, 50, al_makecol(164,46,64), -1);
          al_textout_centre_ex(level_bmp, myfont3, 'EASY', 125, 150, al_makecol(164,46,64), -1);
          al_blit(level_bmp, al_screen, 0, 0, 25, 300, level_bmp^.w, level_bmp^.h);
     end
     else if (level = 2) then
     begin
          al_clear_to_color(level_bmp, al_makecol(0, 0, 0));
          al_textout_centre_ex(level_bmp, myfont3, 'LEVEL', 125, 50, al_makecol(164,46,64), -1);
          al_textout_centre_ex(level_bmp, myfont3, 'MEDIUM', 125, 150, al_makecol(164,46,64), -1);
          al_blit(level_bmp, al_screen, 0, 0, 25, 300, level_bmp^.w, level_bmp^.h);
     end
     else
     begin
         al_clear_to_color(level_bmp, al_makecol(0, 0, 0));
          al_textout_centre_ex(level_bmp, myfont3, 'LEVEL', 125, 50, al_makecol(164,46,64), -1);
          al_textout_centre_ex(level_bmp, myfont3, 'HARD', 125, 150, al_makecol(164,46,64), -1);
          al_blit(level_bmp, al_screen, 0, 0, 25, 300, level_bmp^.w, level_bmp^.h);
     end;
     for i := 0 to 20 do
     begin
         for j := 1 to 10 do
         begin
             if(main_tab[i, j] = 1) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 0, 0));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 2) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 165, 0));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 3) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(0, 200, 0));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 4) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(0, 0, 255));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 5) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 0));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 6) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 0, 254));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(main_tab[i, j] = 7) then
             begin
                  al_rectfill(main_picture, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(128, 128, 50));
                  al_rect(main_picture, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
         end;
     end;
     for i := 1 to 4 do
     begin
         for j := 1 to 4 do
         begin
             if(next_klocek[i, j] = 1) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 0, 0));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 2) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 165, 0));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 3) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(0, 200, 0));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 4) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(0, 0, 255));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 5) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 0));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 6) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 0, 254));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
             if(next_klocek[i, j] = 7) then
             begin
                  al_rectfill(podglad_klocka, skala * (j - 1) + 1, skala * (i - 1) + 1, (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(128, 128, 50));
                  al_rect(podglad_klocka, skala * (j - 1), skala * (i - 1), (skala * (j - 1)) + skala - 1, (skala * (i - 1)) + skala - 1, al_makecol(255, 255, 255));
             end;
         end;
     end;
end;

procedure rysuj_game_over();
var i : integer;
var znak: integer;
var dlugosc_nicku : integer = 0;
var znak_char : char;
var nick: string;
begin
     al_clear_keybuf();
     i := 1;
     while(i < 5) do
     begin
          inc(i);
          al_textout_centre_ex(game_over, myfont3, 'game over', ScreenWidth div 2, (ScreenHeight div 2) - 100, al_makecol(164,46,64), -1);
          al_masked_blit(game_over, al_screen, 0, 0, 0, 0, game_over^.w, game_over^.h);
          al_rest(700);
          al_clear_to_color(game_over, al_makecol(0, 0, 0));
          al_masked_blit(game_over, al_screen, 0, 0, 0, 0, game_over^.w, game_over^.h);
          al_masked_blit(main_picture, bmp, 0, 0, 0, 0, main_picture^.w, main_picture^.h);
          al_blit(bmp, al_screen, 0, 0, 310, 0, bmp^.w, bmp^.h);
          al_blit(podglad_klocka, al_screen, 0, 0, ScreenWidth - 220, 200, podglad_klocka^.w, podglad_klocka^.h);
          al_blit(wynik_gracza, al_screen, 0, 0, 30, 150, wynik_gracza^.w, wynik_gracza^.h);
          al_textout_centre_ex(al_screen, myfont3, 'next', 867, 50, al_makecol(164,46,64), -1);
          al_textout_centre_ex(al_screen, myfont3, 'score', 153, 50, al_makecol(164,46,64), -1);
          al_blit(level_bmp, al_screen, 0, 0, 25, 300, level_bmp^.w, level_bmp^.h);
          al_rest(700);
     end;
     nick := '';
     al_clear_keybuf();
     while(true) do
     begin
          al_clear_to_color(game_over, al_makecol(0, 0, 0));
          al_textout_centre_ex(game_over, myfont3, 'game over', ScreenWidth div 2, (ScreenHeight div 2) - 200, al_makecol(164,46,64), -1);
          al_textout_centre_ex(game_over, myfont3, 'TYPE YOUR NICK', ScreenWidth div 2, (ScreenHeight div 2) + 50, al_makecol(164,46,64), -1);
          if(al_keypressed()) then
          begin
               znak := al_readkey();
               al_clear_keybuf();
               if(znak = 17165) then break;
               if(znak = 16136) then
               begin
                    if(nick <> '') then dec(dlugosc_nicku);
                    nick := copy(nick, 1, length(nick) - 1);
               end
               else
               begin
                    if(dlugosc_nicku <= 20) then
                    begin
                         znak_char := char(znak);
                         nick := nick + znak_char;
                         inc(dlugosc_nicku);
                    end;
               end;
          end;
          if(nick <> '') then
          al_textout_centre_ex(game_over, myfont2, nick, ScreenWidth div 2, (ScreenHeight div 2) + 150, al_makecol(164,46,64), -1);
          al_blit(game_over, al_screen, 0, 0, 0, 0, game_over^.w, game_over^.h);
     end;
     zapis_do_highscore('highscore.txt', nick);
     otworz_menu();
     al_destroy_bitmap(game_over);
end;

function updating() : boolean;
var znak : integer;
begin
     updating := false;
     znak := 0;
     if(al_keypressed()) then
     begin
          znak := al_readkey();
          al_clear_keybuf();
     end;
     if(czy_mozna_opuscic(klocek.indeks, klocek.stan, klocek.posY, klocek.posX)) then
     begin
          inc(wynik_tmp);
          if(tmp_indeks = 0) then tmp_indeks := wylosuj_klocek();
          inc(klocek.posY);
          if(znak = 20992) then
          begin
               if(czy_mozna_w_bok(klocek.indeks, klocek.stan, klocek.posY, klocek.posX, -1)) then klocek.posX := klocek.posX - 1;
          end;
          if (znak = 21248) then
          begin
               if(czy_mozna_w_bok(klocek.indeks, klocek.stan, klocek.posY, klocek.posX, 1)) then klocek.posX := klocek.posX + 1;
          end;
          if(znak = 21504) then
          begin
               if(czy_mozna_obrocic(klocek.indeks, klocek.stan, klocek.posY, klocek.posX)) then obroc_klocek();
          end;

          al_remove_int(@increment_speed);
          al_install_int_ex(@increment_speed, AL_BPS_TO_TIMER(tempo));

          if(al_key[AL_KEY_DOWN] or (znak = 21760)) then
          begin
               al_remove_int(@increment_speed);
               al_install_int_ex(@increment_speed, AL_BPS_TO_TIMER(15));
          end;
          rysuj_siatke_na_planszy(klocek.indeks, klocek.stan, klocek.posY, klocek.posX);
          rysuj_siatke_do_podgladu_next_klocka(tmp_indeks);
          al_rest(10 * level + (level * level));
     end
     else
     begin
          wynik := wynik + wynik_tmp;
          delete_full_line();
          if(THE_END()) then
          begin
               warunek := true;
               updating := true;
               exit();
          end;
          klocek.posY := -1;
          klocek.posX := 3;
          klocek.stan := 1;
          klocek.indeks := tmp_indeks;
          rysuj_siatke_na_planszy(tmp_indeks, 1, -1, 3);
          tmp_indeks := 0;
          wynik_tmp := 0;
     end;
end;

procedure updating2();
var znak : integer;
begin
    znak := 0;
    if(al_keypressed()) then
    begin
         znak := al_readkey();
         al_clear_keybuf();
    end;
    if(czy_mozna_opuscic(klocek.indeks, klocek.stan, klocek.posY, klocek.posX)) then
    begin
         if(al_key[AL_KEY_LEFT] or (znak = 20992)) then
         begin
              if(czy_mozna_w_bok(klocek.indeks, klocek.stan, klocek.posY, klocek.posX, -1)) then klocek.posX := klocek.posX - 1;
         end;
         if (al_key[AL_KEY_RIGHT] or (znak = 21248)) then
         begin
              if(czy_mozna_w_bok(klocek.indeks, klocek.stan, klocek.posY, klocek.posX, 1)) then klocek.posX := klocek.posX + 1;
         end;
         if(al_key[AL_KEY_UP] or (znak = 21504)) then
         begin
              if(czy_mozna_obrocic(klocek.indeks, klocek.stan, klocek.posY, klocek.posX)) then obroc_klocek();
         end;
         rysuj_siatke_na_planszy(klocek.indeks, klocek.stan, klocek.posY, klocek.posX);
         rysuj_siatke_do_podgladu_next_klocka(tmp_indeks);
    end;
end;

begin
  if(initation()) then
  begin
       while(not warunek) do
       begin
            while (speed > 0) do
            begin
                 if(updating()) then
                 begin
                      al_remove_int(@increment_speed);
                      speed := 0;
                      break;
                 end;
                 dec(speed);
            end;
            while(speed2 > 0) do
            begin
                 updating2();
                 dec(speed2);
            end;
            drawing();
            if(warunek) then
            begin
                 rysuj_game_over();
            end;
       end;
       al_stop_sample(music);
       al_destroy_bitmap(main_picture);
       al_destroy_bitmap(menu);
       al_destroy_bitmap(wynik_gracza);
       al_destroy_sample(music);
       al_exit();
  end;
end.

