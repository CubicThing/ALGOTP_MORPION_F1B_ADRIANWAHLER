PROGRAM morpion;

uses sysutils;

TYPE

typegrille = array[1..3,1..3] of string;  //Type grille qui contiendrat la grille.


//---------------AFFICHAGE-------------------------------------------------------------------
//BUT: Afficher la grille.
//ENTREE: Un type grille.
//SORTIE: Un affichage a l'écran d'une grille.

procedure affichergrille(grille : typegrille);

VAR

i,j : integer;

BEGIN

writeln(grille[1,1] , '|' , grille[1,2] , '|' , grille[1,3]);  //Affichage de la grille ligne par ligne.
writeln('-----');
writeln(grille[2,1] , '|' , grille[2,2] , '|' , grille[2,3]);
writeln('-----');
writeln(grille[3,1] , '|' , grille[3,2] , '|' , grille[3,3]);

end;




//----------------TOUR------------------------------------
//BUT: Prendre l'input du joueur, la verifier et la mettre dans la grille.
//ENTREE: Type grille, le signe du joueur actuel, et son nom.
//SORTIE: Ajout d'un symbole dans la grille.


procedure tour(VAR grille : typegrille; joueur : CHAR;nom : string); //On prends la grille, le joueur qui prends son tour et son nom.
VAR

x,y : integer;
vali : boolean;

begin
vali := FALSE;

repeat
    writeln('Joueur : ', nom);
    writeln('Entrez la ligne sur laquelle vous voulez mettre votre signe.');
    readln(x);
    writeln('Entrez la colonne dnas laquelle vous vvoulez mettre votre signe.');
    readln(y);

    IF (grille[x,y] = ' ') AND (x <= 3) AND (x >= 0) AND (y <= 3) AND (y >= 0) then  //On verifie que l'inout est valide : il faut qu'il rentre dans la grille et sur une case non occupée.
    BEGIN
        grille[x,y] := joueur; //Si il est valide, on le met dans la grille et on indique au programme que l'input est valide.
        vali := TRUE;
    END
    ELSE
        writeln('Ce spot est déjà occupé, ou est hors de la grille.');

until vali = TRUE;

end;


//--------------------CHANGEMENT JOUEUR--------------------------------------------------------------------------------
//BUT: Changer la valeure de joueur de x a o et vice versa.
//ENTREE: Le symbole du joueur.
//SORTIE: Le symbole de l'autre joueur.

procedure changerjoueur(var joueur : CHAR);
begin
    IF joueur = 'x' then joueur := 'o' ELSE joueur := 'x';  //Procedure permettant de changer de joueur.
end;


//-------------------CONDITIONS DE VICTOIRE----------------------------------------------------------------------------

{BUT: Les fonction de condition de victoire. Chaque if et else if regarde une ligne, colonne ou diagonale en comparant le mileu au deux autres extemités.
Si on voit des symboles alignés, la fonctions renvoye vrai, indiquant au programme qu'une condition a été remplie.}
//ENTREE: La grille
//SORTIE: Un booleen indiquant si la manche a été gagnée ou pas.


function checkhor(grille : typegrille) : boolean;
begin

   IF ((grille[1,1] = grille[2,1]) AND (grille[2,1] = grille[2,3]) AND (grille[2,1] <> ' ')) then checkhor := TRUE
   ELSE IF ((grille [1,2] = grille[2,2]) AND (grille[2,2] = grille[3,2]) AND (grille[2,2] <> ' ')) then checkhor := TRUE
   ELSE IF ((grille [1,3] = grille[2,3]) AND (grille[2,3] = grille[3,3]) AND (grille[2,3] <> ' ')) then checkhor := TRUE
   ELSE checkhor := FALSE;

end;

function checkver(grille : typegrille) : boolean;
begin

   IF ((grille [1,1] = grille[1,2]) AND (grille[1,2] = grille[1,3]) AND (grille[1,2] <> ' ')) then checkver := TRUE
   ELSE IF ((grille [2,1] = grille[2,2]) AND (grille[2,2] = grille[2,3]) AND (grille[2,2] <> ' ')) then checkver := TRUE
   ELSE IF ((grille [3,1] = grille[3,2]) AND (grille[3,2] = grille[3,3]) AND (grille[3,2] <> ' ')) then checkver := TRUE
   ELSE checkver := FALSE;

end;

function checkdiag(grille : typegrille) : boolean;
begin

   IF ((grille [1,1] = grille[2,2]) AND (grille[2,2] = grille[3,3]) AND (grille[2,2] <> ' ')) then checkdiag := TRUE
   ELSE IF ((grille [1,3] = grille[2,2]) AND (grille[2,2] = grille[3,1]) AND (grille[2,2] <> ' ')) then checkdiag := TRUE
   ELSE checkdiag := FALSE;

end;


//----------------------------MAIN------------------------------------

VAR

joueur : CHAR;
grille : typegrille;
manches,i,j : integer;
pto,ptx,nbtour  : integer;
nomJoueurx : string;
nomjoueury : string;
ft : text;

begin
    
//--------------------INITIALISATION-----------------------------------

assign(ft,'morpionlog.txt');
append(ft);

joueur := 'x';

writeln('Entrez le nom du joueur x');
readln(nomjoueurx);

writeln('Entrez le nom du joueur y');
readln(nomjoueury);

writeln('Combien de manche faudrat-il gagner?');
repeat readln(manches) until manches > 0;

Writeln (ft,'La partie entre le joueur ', nomjoueurx,' et ', nomjoueury, ' a commencé a : ' , DateTimeToStr(Now));

//------------------ DEBUT PARTIE-------------------------

repeat
    for i := 1 to 3 do
        for j := 1 to 3 do
            grille[i,j] := ' ';
    nbtour := 0;

    repeat
        affichergrille(grille);
        if joueur = 'x' then tour(grille,joueur,nomJoueurx) else tour(grille,joueur,nomJoueury);
        nbtour := nbtour +1;
        changerjoueur(joueur);
    until(nbtour = 9) OR (checkhor(grille) = TRUE) OR (checkver(grille) = TRUE) OR (checkdiag(grille) = TRUE);
    
    //-------------------Fin tour.    
    
    changerjoueur(joueur);
    if nbtour <> 9 then
    BEGIN
        if joueur = 'x' then
        BEGIN
            writeln('Le joueur ', nomjoueurx, ' a gagne le round.');
            writeln(ft,nomjoueurx,' a gagné la manche en ', IntToStr((nbtour div 2) + 1) , ' coups.')
        END    
        else
        BEGIN    
            writeln('Le joueur ', nomjoueury, ' a gagne le round.');
            writeln(ft,nomjoueury,' a gagné la manche en ',IntToStr((nbtour div 2) + 1), ' coups.')           
        END;
        if joueur = 'o' then pto := pto + 1 else ptx := ptx + 1;
    END
    ELSE
    BEGIN
        writeln('Personne n''a gagne le round!');
        writeln(ft,'Manche nulle.');
    END;
until (pto = manches) OR (ptx = manches); 

//--------------------Fin partie.

if joueur = 'x' then
BEGIN
    writeln(ft,'Le joueur ', nomjoueurx, ' a gagne la partie en ', manches, ' manche(s) !');
    writeln(nomjoueurx , ' a gagne!');
END    
else
BEGIN
    writeln(ft,'Le joueur ', nomjoueury, ' a gagne la partie ', manches, ' manche(s) !');
    writeln(nomjoueury, 'a gagne!');
    
END;
readln();

writeln(ft,'FIN DE PARTIE ', DateTimeToStr(Now), '----------------------------------------------------');
writeln(ft,'');
writeln(ft,'');

close(ft);
end.
