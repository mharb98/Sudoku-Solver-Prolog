game([[4,0,2,6,7,0,0,9,1],
	  [0,0,0,9,0,8,0,7,0],
	  [0,0,0,0,0,0,0,4,3],
	  [7,0,1,8,5,0,0,0,0],
	  [5,0,0,3,0,0,1,6,0],
	  [0,0,0,1,0,4,0,0,0],
	  [3,0,7,0,0,0,6,0,0],
	  [0,0,0,0,0,1,4,5,0],
	  [0,0,0,7,0,0,3,0,9]]).

checkBlock(R,C,B):-((R =< 2 , C =< 2) -> B=0);
	((R =< 2 , C > 2 ,C =< 5) -> B=1);
	((R =< 2 , C > 5 ,C =< 8) -> B=2);
	((R > 2 , R =<5 ,C =<2 ) -> B=3);
	((R > 2 , R =<5 ,C > 2,C =<5 ) -> B=4);
	((R > 2 , R =<5 ,C > 5,C =<8 ) -> B=5);
	((R > 5 , R =<8 ,C =<2 ) -> B=6);
	((R > 5 , R =<8 ,C > 2,C =<5 ) -> B=7);
	((R > 5 , R =<8 ,C > 5,C =<8 ) -> B=8).

getRow([H|T],0,H):-!.
getRow([H|T],N,X):-N1 is N-1,
	getRow(T,N1,X).
	
getBlock([[A1,A2,A3,A4,A5,A6,A7,A8,A9],
		  [B1,B2,B3,B4,B5,B6,B7,B8,B9],
	      [C1,C2,C3,C4,C5,C6,C7,C8,C9],
	      [D1,D2,D3,D4,D5,D6,D7,D8,D9],
	      [E1,E2,E3,E4,E5,E6,E7,E8,E9],
	      [F1,F2,F3,F4,F5,F6,F7,F8,F9],
	      [G1,G2,G3,G4,G5,G6,G7,G8,G9],
	      [H1,H2,H3,H4,H5,H6,H7,H8,H9],
	      [I1,I2,I3,I4,I5,I6,I7,I8,I9]],N,L):-((N =:= 0) -> L=[A1,A2,A3,B1,B2,B3,C1,C2,C3]);
											  ((N =:= 1) -> L=[A4,A5,A6,B4,B5,B6,C4,C5,C6]);
											  ((N =:= 2) -> L=[A7,A8,A9,B7,B8,B9,C7,C8,C9]);
											  ((N =:= 3) -> L=[D1,D2,D3,E1,E2,E3,F1,F2,F3]);
											  ((N =:= 4) -> L=[D4,D5,D6,E4,E5,E6,F4,F5,F6]);
											  ((N =:= 5) -> L=[D7,D8,D9,E7,E8,E9,F7,F8,F9]);
											  ((N =:= 6) -> L=[G1,G2,G3,H1,H2,H3,I1,I2,I3]);
											  ((N =:= 7) -> L=[G4,G5,G6,H4,H5,H6,I4,I5,I6]);
											  ((N =:= 8) -> L=[G7,G8,G9,H7,H8,H9,I7,I8,I9]).	
	
getColumn([],_,[]).	
getColumn([H|T],N,[H2|T2]):-columnHelper(H,N,H2),
		getColumn(T,N,T2),!.
		

columnHelper([E|T],0,E).
columnHelper([H|T],N,E):-N1 is N-1,
	columnHelper(T,N1,E).
		
checkMiss(R,C,B,10,X,[]).

checkMiss(R,C,B,N,X,[H|T]):-
	getRow(X,R,L1),
	getColumn(X,C,L2),
	getBlock(X,B,L3),
	((\+member(N,L1),\+member(N,L2),\+member(N,L3))->H is N),
	N1 is N+1,
	checkMiss(R,C,B,N1,X,T),!.
	
checkMiss(R,C,B,N,X,T):-N1 is N+1,
	checkMiss(R,C,B,N1,X,T),!.
	
modifyElement(0,N,[H|T],[N|T]).		
modifyElement(C,N,[H|T],[H|T2]):-C1 is C-1,
	modifyElement(C1,N,T,T2).

modifyRow(0,[H|T],L,[L|T]).
modifyRow(R,[H|T],L,[H|T2]):- R1 is R-1,
	modifyRow(R1,T,L,T2).

modifyTable(R,C,N,X,NewX):-getRow(X,R,L),
	modifyElement(C,N,L,NewL),
	modifyRow(R,X,NewL,NewX).

getZero(C,[0|T],C):-!.

getZero(C,[H|T],C2):-C1 is C+1,
	getZero(C1,T,C2).

checkZero(9,X,R,C):- R is 9,
	C is 9,!.

checkZero(R,X,R,C):-getRow(X,R,L),
	N is 0,
	member(N,L),
	getZero(0,L,C),!.

checkZero(R,X,R2,C):-getRow(X,R,L),
	N is 0,
	\+member(N,X),
	R1 is R+1,
	checkZero(R1,X,R2,C).

getList(R,C,X,[],[]).
getList(R,C,X,[H|T],[H2|NO]):-modifyTable(R,C,H,X,NewX),
	checkZero(R,NewX,R2,C2),
	H2 = [R2,C2,NewX],
	getList(R,C,X,T,NO).

dfs([[9,9,S]|Open],S).

dfs([[R,C,X]|Open],S):-checkBlock(R,C,B),
	checkMiss(R,C,B,1,X,L),
	length(L,N),
	(N =:= 0),
	dfs(Open,S).
	
dfs([[R,C,X]|Open],S):-checkBlock(R,C,B),
	checkMiss(R,C,B,1,X,L),
	length(L,N),
	(N > 0),
	getList(R,C,X,L,NO),
	append(NO,Open,NewOpen),
	dfs(NewOpen,S).

sudoku(S):-game(X),
	checkZero(0,X,R,C),
	dfs([[R,C,X]],S).
	
