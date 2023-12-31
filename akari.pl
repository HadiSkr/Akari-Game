:-dynamic light/2.
:-dynamic cell_x/2.




%size(Rows, Columns).
size(8,8).
%wall(Row, Column).
wall(1,6).
wall(2,2).
wall(2,3).
wall(3,7).
wall(4,1).
wall(4,5).
wall(5,4).
wall(5,8).
wall(6,2).
wall(7,6).
wall(7,7).
wall(8,3).

%wall_num(Row, Column, Num).
wall_num(1,6,1).
wall_num(2,2,3).
wall_num(3,7,0).
wall_num(5,4,4).
wall_num(5,8,0).
wall_num(6,2,2).
wall_num(7,6,1).
%not(wall_num(Row,Column,_))

ligth(1,2).
ligth(2,1).
ligth(3,2).
ligth(1,7).
ligth(2,8).
ligth(4,4).
ligth(4,6).
ligth(5,3).
ligth(5,5).
ligth(6,1).
ligth(6,4).
ligth(7,2).
ligth(7,8).
ligth(8,6).






%light_neb(Row,Column):- R1 is Row + 1 ,R2 is Row -1,C1 is Column -1,C2
% is Column +1,wall_num(Row,Column,_),append([R1,],[],X).


%count_neb_light(Row,Column,X):-


 %all_cells_neb(Row,Column,X):-R1 is Row + 1,R2 is Row -1,C1 is
 %Column-1,C2 is Column +1,
  %findall(Column,not(wall(R1,Column),Z1)),findall(Row,not(wall(Row,C2),Z2)),append(Z1,Z2,Z6)
  %,findall(Column,not(wall(R2,Column),Z3)),findall(Row,not(wall(Row,C1),Z4)),append(Z3,Z4,Z5),append(Z5,Z6,X).



%solved:- all_cells_lighted,no_double_light Hlight_count_correct .
%light(Row, Col):-Row


%assert(light(0)).







printPuzzle([]).
printPuzzle(Xs) :- nl,
      write('----------------------'), nl,
      printBand(Xs,Xs1),
      printBand(Xs1,Xs2),
      printBand(Xs2,Xs3),
      printBand(Xs3,_),
     write('----------------------'),nl.



printBand(Xs,Xs2) :-
   printRow(Xs,Xs1), nl,
   printRow(Xs1,Xs2), nl.

printRow(Xs,Xs2) :-
   printTriplet(Xs,Xs1),
   printTriplet(Xs1,Xs2).

printTriplet(Xs,Xs4) :-
   printElement(Xs,Xs1), write('  '),
   printElement(Xs1,Xs2), write('  '),
   printElement(Xs2,Xs3),write('  '),
   printElement(Xs3,Xs4),write('  ').

printElement([X|Xs],Xs) :- var(X), !, write('.').
printElement([X|Xs],Xs) :- write(X).



puzzle(1,P) :-
   P = [_,o,_,_,_,1,o,_,
        o,3,x,_,_,_,_,_,
        _,o,_,_,_,_,0,_,
        x,_,_,o,x,_,_,_,
        _,_,o,4,o,_,_,_,
        o,2,_,o,_,_,_,_,
        _,o,_,_,_,1,x,_,
        _,_,x,_,_,o,_,_].


puzzle(2,P) :-
   P = [_,_,_,_,_,1,_,_,
        _,3,_,_,_,_,_,_,
        _,_,_,_,_,_,_,_,
        _,_,_,_,_,_,_,_,
        _,_,_,4,_,_,_,_,
        _,2,_,_,_,_,_,_,
        _,_,_,_,_,1,_,_,
        _,_,_,_,_,_,_,_].

element_at(X,[X|_],1).
element_at(X,[_|L],K) :- K > 1, K1 is K - 1, element_at(X,L,K1).


indexElement(Row,Column,Index):-size(N,_),Index is N *Row + Column.

getRow(Index,R):-size(N,_),Row is  Index/(N+1), R is integer(float_integer_part(Row))+1.

getColumn(Index,N):-size(N,_), R is Index mod N  , R = 0.
getColumn(Index,Index):-size(N,_), Index >=1, Index < N.
getColumn(Index,Column):-size(N,_),Column is Index mod N .


getElement(Row,Column,X):-R is Row -1 , puzzle(1,P),indexElement(R,Column,N),element_at(X,P,N).

%getNeighbors(Row,Column,[X1,X2,X3,X4]):-
%R1 is Row + 1,R2 is Row -1
%,C1 is Column-1,C2 is Column +1
%,indexElement(R1,Column,X1),indexElement(R2,Column,X2)
%,indexElement(Row,C1,X3),indexElement(Row,C2,X4).

test(N) :- puzzle(N,P),printPuzzle(P), nl.





%****************** 1 ********************************

%إجرائية تعطي سلسلة تمثل "جيران" خلية ما ذات سطر وعمود



cell(X,Y):-X>0,X<9,Y>0,Y<9.

neighbor(X,Y,NX,Y):-
    NX is X-1,not(cell_x(NX,Y)),
    cell(NX,Y).

neighbor(X,Y,NX,Y):-
    NX is X+1,
    not(cell_x(NX,Y)),
    cell(NX,Y).

neighbor(X,Y,X,NY) :-
    NY is Y-1,
    not(cell_x(X,NY)),

    cell(X,NY).

neighbor(X,Y,X,NY) :-
    NY is Y+1,
    not(cell_x(X,NY)),
    cell(X,NY).

allneighbors(X,Y,L) :-
    findall(neighbor(NX,NY),neighbor(X,Y,NX,NY),L).






r_row(Column,X,[]):-R is X + 1 ,(R>8;wall(Column,R)),!.
r_row(Column,X,[cell(Column,R)|T]):- R is X + 1,not(light(X,Column))
,r_row(Column,R,T).

l_row(Column,X,[]):-R is X - 1 ,(R<1;wall(Column,R)),!.
l_row(Column,X,[cell(Column,R)|T]):- R is X - 1,not(light(X,Column))
,l_row(Column,R,T).


%****************** 2 ********************************

% إجرائية تعطي سلسلة تمثل مجموعة خلايا السطر المحيطة بخلية ما من اليمين واليسار والمحاطة بحدود الرقعة أو ●بحائط

row(X,Y,Z):-r_row(X,Y,Z1),l_row(X,Y,Z2)  ,append(Z1,Z2,Z).




up_column(Row,X,[]):-C is X + 1 ,(C>8;wall(C,Row)),!.
up_column(Row,X,[cell(C,Row)|T]):- C is X + 1,not(light(Row,C))
,up_column(Row,C,T).

down_column(Row,X,[]):-C is X - 1 ,(C<1;wall(C,Row)),!.
down_column(Row,X,[cell(C,Row)|T]):- C is X - 1,not(light(Row,C))
,down_column(Row,C,T).




%****************** 3 ********************************

%تثل مجموعة خلايا الأعمدة المحيطة بخلية ما من الأعلى والأدنى والم

column(X,Y,Z):-up_column(Y,X,Z1),down_column(Y,X,Z2),append(Z1,Z2,Z).




list_row_and_column(X,Y,Z):-column(X,Y,Z1),row(X,Y,Z2),append(Z1,Z2,Z).





count_inlist([],0).
count_inlist([cell(X,Y)|T],N) :-ligth(X,Y),  count_inlist(T,N1), N is N1 + 1.
count_inlist([cell(X,Y)|T],N) :- not(ligth(X,Y)), count_inlist(T,N).


%****************** 4 ********************************

%إجرائية تقوم بعد خلايا المصباح الموجودة ضمن سلسلة تحوي خلايا تكون محددة بسطرها وعمودها

count_list_light(X,Y,N):-list_row_and_column(X,Y,Z),count_inlist(Z,N).



%****************** 5 ********************************


%إجرائية تتحقق من كون خلية ما مضاءة

cell_is_light(X,Y):-ligth(X,Y);(count_list_light(X,Y,N),N>0).




count([],0).
count([neighbor(X,Y)|T],N) :-ligth(X,Y),  count(T,N1), N is N1 + 1.
count([neighbor(X,Y)|T],N) :- not(ligth(X,Y)), count(T,N).

count_neb_light(Row,Column,N):-allneighbors(Row,Column,L),count(L,N).



%****************** 6 ********************************

%إجرائية تتحقق من أن خلية حائط مرقمة محاطة بخلايا مصباح عددها يساوي الرقم في الخلية.

cell_wall_num_is_complet(X,Y,N):-count_neb_light(X,Y,NL),N = NL.











check2(Row,Column):-size(N,M),Row =< N ,Row > 0 ,Column =< M ,Column > 0.

all_row(X,Y):-not(check2(X,Y)),!.
all_row(X,Y):-Y1 is Y+1,cell_is_light(X,Y),all_row(X,Y1).

all_cell(X,Y):-not(check2(X,Y)),!.
all_cell(X,Y):-X1 is X +1,all_row(X,Y),all_cell(X1,Y).



%****************** 7 ********************************
%تتأكد أن جميع الخلايا في الرقعة مضاءة من قبل مصباح. all_cells_lighted

all_cells_lighted:-all_cell(1,1).



all_light(L):-findall(ligth(X,Y),ligth(X,Y),L).

check_double_light([]).
check_double_light([ligth(X,Y)|T]):- not((count_list_light(X,Y,N),N>0)),check_double_light(T).



%****************** 8 ********************************


%. تتأكد أن خلايا المصباح ليست مضاءة من قبل مصباح آخر 1 no_double_light 2. إجرائية

no_double_light:-all_light(L),check_double_light(L).




all_wall_num(L):-findall(wall_num(X,Y,N),wall_num(X,Y,N),L).
check_light_count_correct([]).
check_light_count_correct([wall_num(X,Y,N)|T]):- cell_wall_num_is_complet(X,Y,N),check_light_count_correct(T).

%****************** 9 ********************************

%تتأكد من عدد خلايا المصباح المحيطة بجميع خلايا الحائط المرقمة. light_count_correct 3.

light_count_correct:-all_wall_num(L),check_light_count_correct(L).




%****************** solved ********************************


solved:- all_cells_lighted,
no_double_light ,
light_count_correct .




set_all_cell_light([],[]).
set_all_cell_light([ligth(X,Y)|T1],Z):-list_row_and_column(X,Y,H),set_all_cell_light(T1,T2),append(H,T2,Z).


%بجيب كا الخلايا يلي ضواها الضوء في سطره وعموده
all_cell_light(L):-all_light(X),set_all_cell_light(X,L).


%بجيب الخلايا المجاورة لخلية صفر وحدة

allneighborsN0(X,Y,L) :-
    findall(cell(NX,NY),neighbor(X,Y,NX,NY),L).


%بجيب كل الخلايا يلي ارقامن صفر

get_wall_num0(L):-findall(wall_num(X,Y,0),wall_num(X,Y,0),L).


get_neb_N0([],[]).
get_neb_N0([wall_num(X,Y,0)|T1],Z):-allneighborsN0(X,Y,H),get_neb_N0(T1,T2),append(H,T2,Z).


% بجيب كل مجاورات الخلايا يلي ارقامن صفري

get_neb_all_N0(L):-get_wall_num0(X),get_neb_N0(X,L).


%assert(cell_x(X,Y))  بعرف بشكل ديناميكي الخلايا المسبعدة
set_cell_x([]).
set_cell_x([cell(X,Y)|T]):-assert(cell_x(X,Y)),set_cell_x(T).



% بعرف كل الخلايا المضائة وكل الخلايا يلي بجوارات الصفر كخلايا مستبعدة من وضع ضوء فيها

set_cell_all_x:-get_neb_all_N0(L1),all_cell_light(L2),append(L1,L2,L),set_cell_x(L).








length_list([], 0).
length_list([_|T], N) :- N is N1+1, length_list(T, N1).


% بترجع عدد الجوارات
count_neb(Row,Column,N):-allneighbors(Row,Column,L),length_list(L,N).




get_neb_N([],[]).
get_neb_N([wall_num(Row,Column,N1)|T1],Z):-count_neb(Row,Column,N2),N1=N2,get_neb_N(T1,T2),append([cell(Row,Column)],T2,Z).
get_neb_N([wall_num(Row,Column,N1)|T1],T2):-count_neb(Row,Column,N2),N1 \= N2,get_neb_N(T1,T2).



%بجيب كل  جوارات الخلايا المرقمة في حال عدد الجوارات  بساوي الرقم تبعا من اجل وضع ضوء في تلك الخلايا فورا

list_neb_count_Equal_num(X):-get_wall_num(L),get_neb_N(L,X).









%بتعرف الخلية المصباح بشكل دينامكي assert(light(X,Y))
set_light([]).
set_light([cell(X,Y)|T]):-assert(light(X,Y)),set_light(T).



% بتعرف كل المجاورات كخلية مصباح للارقام يلي بتساوي عدد مجاوراتا بشكل ديناميكي


set_cell_light:-list_neb_count_Equal_num(L),set_light(L).
































