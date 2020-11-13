% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Tienda: Servidor que administra las suscripciones de socios y la venta de productos.
-module(tienda).
-export([init_tienda/0, tienda_serv/1]).

% Datos SCHEMA: [[socios, []]], [productos, []], [pedidos, []]]
init_tienda() ->
    register(servidor_tienda,
        spawn('tienda@Inakis-MacBook-Pro', tienda, tienda_serv, [[]])).
tienda_serv(Datos) ->
    busca(inaki, Datos),
    receive
        {suscribe, {PID, Socio}} -> 
            % Añadir socio a Datos
            tienda_serv(subscribe_socio(PID, Socio, Datos));

        {PID, _} ->
            io:format("Hola, soy la tienda ~n"),
            PID ! "¡Mensaje llego bien a tienda!",
            tienda_serv(Datos);
        _ -> 
            io:format("Mensaje incorrecto ~n")

    end.

subscribe_socio(Socio, Datos) ->
    io:format("Nuevo socio ~p suscrito~n", [Socio]).
    
subscribe_socio(De, Quien, []) ->
    io:format("Entra aqui~n"),
        [{De, Quien}].

busca(Quien, [{Quien, Valor}|_]) -> 
    io:format("~p~n", [Quien]),
    Valor;
busca(Quien, [_|T]) ->
    io:format("~p~n", [Quien]),
    busca(Quien, T);
busca(_, _) -> 
    io:format("indefinido~n"),
    indefinido.

% suscribe_socio(_, [_, ListaSocio]) ->

% suscribe_socio(_, []) -> 

