% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Tienda: Servidor que administra las suscripciones de socios y la venta de productos.
-module(tienda).
-export([init_tienda/0, tienda_serv/1]).

% Datos SCHEMA: [[{PID_Socio, Socio}], [productos], [servicios]]
init_tienda() ->
    register(servidor_tienda,
        spawn('tienda@Inakis-MacBook-Pro', tienda, tienda_serv, [[[],[],[]]])).
tienda_serv(Datos) ->
    io:format("~p~n", [Datos]),
    receive
        {suscribe, {PID, Socio}} -> 
            % Añadir socio a Datos
            New_socio = subscribe_socio(PID, Socio, Datos),
            if hd(New_socio) == ok ->
                PID ! ok,
                tienda_serv(tl(New_socio));
            true -> PID ! error, tienda_serv(Datos)
            end;

        {PID, _} ->
            io:format("Hola, soy la tienda ~n"),
            PID ! "¡Mensaje llego bien a tienda!",
            tienda_serv(Datos);
        _ -> 
            io:format("Mensaje incorrecto ~n")

    end.
    
subscribe_socio(PID, Socio, [ListaSocios | R]) ->
    io:format("Socio ~p se añadio~n", [Socio]),
    case busca(Socio, ListaSocios) of 
      false -> [ok | [ListaSocios ++ [{PID, Socio}] | R]];
      true -> [error | [ListaSocios | R]]
    end
    . 

busca(Valor, [{_, Valor}|_]) -> 
    true;
busca(Valor, [_|T]) ->
    busca(Valor, T);
busca(_, _) -> 
    false.


getSocios(Datos) -> hd(Datos).
getProductos(Datos) -> hd(tl(Datos)).
getpedidos(Datos) -> tl(tl(Datos)).

% busca(Quien, [{Quien, Valor}|_]) -> 
%     io:format("~p~n", [Quien]),
%     Valor;
% busca(Quien, [_|T]) ->
%     io:format("~p~n", [Quien]),
%     busca(Quien, T);
% busca(_, _) -> 
%     io:format("indefinido~n"),
%     indefinido.

% suscribe_socio(_, [_, ListaSocio]) ->

% suscribe_socio(_, []) -> 

