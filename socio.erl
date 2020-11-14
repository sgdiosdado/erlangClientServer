% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Socio: Compradores que se suscribieron al pagar la membresía de la tienda.

-module(socio).
-export([suscribir_socio/1]).

% Funcion getHostName: Regresa el nombre largo del servidor (nombre@máquina)
getHostname() -> 'tienda@Inakis-MacBook-Pro'.

suscribir_socio(Socio) ->
    Matriz = getHostname(),
    monitor_node(Matriz, true),
    {servidor_tienda, Matriz} ! {suscribe, {self(), Socio}},
    receive
        {nodedown, Matriz} ->
            no;
        ok ->
            io:format("Socio ~p suscrito correctamente~n", [Socio]);
        error ->
            io:format("Hubo un error al suscribir el socio ~p~n", [Socio])
    after 2000 ->
        io:format("TIME OUT ERROR~n")
    end.


