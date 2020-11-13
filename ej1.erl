-module(ej1).
-import(lists, [map/2]).
-export([mayor/3, suma/1, negativos/1, filtra/2, impares/1]).

% Recibe tres argumentos y regresa el mayor de entre ellos
% Casos prueba:
%   ej1:mayor(7,-5,3).
%   ej1:mayor(1,2,3).
%   ej1:mayor(9,9,9).
mayor(A,B,C) -> 
  if
    ((A > B) and (A > C)) -> A;
    ((B > A) and (B > C)) -> B;
    true -> C
  end
.

% Recibe un argumento y regresa la sumatoria de la fórmula:
%   ∑(2k - 1); k = 0...N
%
% Casos prueba:
%   ej1:suma(0).
%   ej1:suma(3).
suma(0) -> -1;
suma(N) when N > 0 ->
  (2*N -1 + suma(N-1)).

% Recibe una lista de números enteros y regresa una lista de los que sean menores a cero
% Casos prueba:
%   ej1:negativos([3,3,3]).
%   ej1:negativos([2,-3,4,-5]).
%   ej1:negativos([-9,-2,5,3,-2]).
negativos([]) -> [];
negativos(List) ->
  if
    hd(List) < 0 -> [hd(List) | negativos(tl(List))];
    true -> negativos(tl(List))
  end
.

% Recibe una función, una lista y regresa una nueva lista filtrada a utilizando la función dada
% Casos prueba:
%   ej1:filtra(fun(X) -> X > 1 end, [-1,2,-3]).
%   ej1:filtra(fun(X) -> X < 0 end, [-1,2,-3]).
filtra(_, []) -> [];
filtra(Func, List) ->
  case Func(hd(List)) of
    true -> [hd(List) | filtra(Func, tl(List))];
    false -> filtra(Func, tl(List))
  end
.

% Recibe una lista de listas y regresa una nueva lista de listas sólo con impares
% Casos prueba:
%   ej1:impares([[1,2,3],[4,5,6]]).
%   ej1:impares([[2,2],[2,2],[2,2]]).
impares(L) -> 
  lists:map(fun(Sublist) -> lists:foldr(fun lists:append/2, [], odds(Sublist)) end, L)
.
% Recibe una lista de números enteros y regresa una nueva lista con sólo los impares
odds(L) -> lists:map(fun(Num) -> if (Num rem 2) == 0 -> []; true -> [Num] end end, L).